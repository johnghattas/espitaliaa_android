import 'package:espitalia/bloc/admin_bloc.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/models/admin_time_table.dart';
import 'package:espitalia/shred/custom_button_widget.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

void main() => runApp(MyApp());

typedef ValidateFunction = String? Function(String? value);

class DoctorAddInformation extends StatefulWidget {
  static const NAME = 'doctorInformation';

  @override
  _DoctorAddInformationState createState() => _DoctorAddInformationState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: DoctorAddInformation(),
    );
  }
}

///Use in this file only
class TimeTextField extends StatelessWidget {
  final VoidCallback? onPressed;
  final ValidateFunction? onSaved;
  final TextEditingController? controller;
  final String hint;
  final String title;
  final String? initialValue;
  final bool enabled;

  const TimeTextField({
    Key? key,
    this.onPressed,
    this.controller,
    this.hint = '',
    this.title = '',
    this.enabled = false,
    this.onSaved,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kPrimaryColor)),
        // width: 100,
        height: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: kStyle.copyWith(
                    letterSpacing: 1.6, fontWeight: FontWeight.normal)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                initialValue: initialValue,
                onSaved: onSaved,
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                // inputFormatters: [TimeFormat()],
                decoration: InputDecoration(
                  isCollapsed: true,
                  enabled: enabled,
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAddInformationState extends State<DoctorAddInformation> {
  final List days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'thursday',
    'Friday'
  ];
  final isFirstCome = 'is_first_come';
  final isInterval = 'is_interval';

  final _formKey = GlobalKey<FormState>();
  List<TimeTable> _timeTables = [];
  List<List<TextEditingController>> _textsEditing = [];

  int _duration = 0;
  late String _token;

  late String _functionValue;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title:
            Text('Add your information', style: TextStyle(color: kWhiteColor)),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        onTapDown: (details) => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: BlocConsumer<AdminBloc, AdminState>(
                  listener: (context, state) {
                    if (state is GetTableState) {
                      _putData(state);
                    } else if (state is ChangeDropState) {
                      _functionValue = state.method;
                    } else if (state is EditTablesSuccessState) {
                      _showSnakbar(context);
                    } else if (state is ErrorGetTablesState) {
                      _showSnakbar(context,
                          text: state.message, color: Colors.red);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingGetTablesState) {
                      return Container(
                          height: (SizeConfig.height ?? 600) - 60,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ));
                    }
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DropdownButton(
                            items: [
                              DropdownMenuItem(
                                child: Text('Is First come'),
                                value: isFirstCome,
                              ),
                              DropdownMenuItem(
                                child: Text('Is Interval'),
                                value: isInterval,
                                onTap: () {},
                              ),
                            ],
                            value: _functionValue,
                            onTap: () {},
                            onChanged: (value) {
                              context
                                  .read<AdminBloc>()
                                  .add(ChangeDropEvent((value as String)));
                            },
                          ),
                          _functionValue == isInterval
                              ? SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: TimeTextField(
                                    hint: '30',
                                    initialValue: _duration.toString(),
                                    title: 'Duration',
                                    enabled: true,
                                    onSaved: (String? value) {
                                      _duration = int.parse(value ?? '0');
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                          ...List.generate(
                            7,
                            (index) => _buildColumn(index, context),
                          ),
                          SizedBox(height: 80)
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
              child: CustomButton(
                onPressed: _updateData,
                child: Text(
                  'Update your data',
                  style: TextStyle(color: kWhiteColor),
                ),
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = Hive.box('user_data').get('token');
    context.read<AdminBloc>().add(GetTablesEvent(_token));

    _initTimeTableList();

    _functionValue = isFirstCome;
  }

  Column _buildColumn(int index, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
                value: _timeTables[index].isAvail ?? false,
                onChanged: (value) {
                  context.read<AdminBloc>().add(ChangeCheckboxEvent());

                  _timeTables[index].isAvail = value;
                }),
            Text(days[index]),
          ],
        ),
        (_timeTables[index].isAvail ?? false)
            ? Container(
                child: GridView(
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 20,
                    crossAxisCount: 3,
                    childAspectRatio: (SizeConfig.width! / 3 - 40) / 70,
                  ),
                  shrinkWrap: true,
                  children: [
                    TimeTextField(
                      controller: _textsEditing[index][0],
                      hint: '10:00 AM',
                      title: 'Start time',
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 12, minute: 00),
                            helpText: 'Start Time');
                        if (time != null) {
                          var format = time.format(context);
                          _timeTables[index].startTime = format;
                          _textsEditing[index][0].text = format;
                        }
                      },
                    ),
                    TimeTextField(
                      controller: _textsEditing[index][1],
                      hint: '05:00 PM',
                      title: 'End time',
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 17, minute: 00),
                            helpText: 'End Time');
                        if (time != null) {
                          var format = time.format(context);
                          _timeTables[index].endTime = format;
                          _textsEditing[index][1].text = format;
                        }
                      },
                    ),
                    AnimatedOpacity(
                      opacity: _functionValue == isFirstCome ? 1 : 0,
                      duration: Duration(milliseconds: 500),
                      child: TimeTextField(
                        hint: '50',
                        initialValue: _timeTables[index].countAtt?.toString()??'0',
                        title: 'Count Attendee',
                        enabled: true,
                        onSaved: (String? value) {
                          _timeTables[index].countAtt =
                              int.parse(value?.trim() ?? '0');
                        },
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }

  _initTimeTableList() {
    for (int i = 0; i < 7; i++) {
      _timeTables.add(TimeTable.init()
        ..day = (days[i] as String).substring(0, 3).toLowerCase());
      _textsEditing.add([TextEditingController(), TextEditingController()]);
    }
  }

  void _putData(GetTableState state) {
    List<TimeTable> tables = state.adminTimeTable.timeTables!;
    for (int i = 0; i < tables.length; i++) {
      TimeTable? table = tables[i];

      int j = days.indexWhere((element) =>
          element.substring(0, 3).toLowerCase() == table.day?.toLowerCase());

      _timeTables[j] = table;
      _textsEditing[j][0].text = table.startTime;
      _textsEditing[j][1].text = table.endTime;
    }
    _duration = state.adminTimeTable.durationMin ?? 0;
    _functionValue = _valueFunction(state.adminTimeTable.isFirstCome);
  }

  void _showSnakbar(BuildContext context, {String? text, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color ?? Colors.green,
        content: Container(
            height: 20,
            alignment: Alignment.center,
            child: Text(
              text ?? "Success Editing data",
              style: TextStyle(color: kWhiteColor),
            ))));
  }

  void _updateData() {
    _formKey.currentState?.save();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<AdminBloc>().add(EditTablesEvent(
        _token,
        AdminTimeTable(
            durationMin: _duration,
            isFirstCome: _functionValue == isFirstCome ? true : false,
            timeTables: _timeTables)));
  }

  String _valueFunction(bool value) => value ? isFirstCome : isInterval;
}
