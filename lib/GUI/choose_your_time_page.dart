import 'package:equatable/equatable.dart';
import 'package:espitalia/bloc/appointments_bloc.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/models/reserve_model.dart';
import 'package:espitalia/shred/alerts_class.dart';
import 'package:espitalia/shred/custom_button_widget.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ActiveInterval extends Equatable {
  String? interval;
  bool state;

  bool isSelected;
  late String date;

  ActiveInterval(this.interval, [this.state = false, this.isSelected = false]);

  ActiveInterval.init(
      {required this.date, this.state = false, this.isSelected = false});

  String get day {
    var lowerCase = date.toLowerCase();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (lowerCase == 'today') {
      return DateFormat('EEEE').format(now);
    }
    if (lowerCase == 'tomorrow') {
      return DateFormat('EEEE').format(tomorrow);
    } else
      return date.split(' ').first;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [interval, date];
}

class ChooseTime extends StatefulWidget {
  final List<Appointment>? listAppoints;
  final int? index;
  final Doctor? doctor;

  ChooseTime(
      {Key? key, required this.listAppoints, required this.index, this.doctor})
      : super(key: key);

  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}


class _ChooseTimeState extends State<ChooseTime> with Alerts {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<ExpandableController>? _listControllers;

  late List<List<ActiveInterval>> intervals;

  ActiveInterval? _activeInterval;

  bool _errorShow = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    print('build');
    return Theme(
      data: ThemeData(
        accentColor: kPrimaryColor,
        primaryColor: kPrimaryColor,
        primarySwatch: kPrimaryColor,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: kWhiteColor),
          backgroundColor: kPrimaryColor,
        ),
      ),
      child: WillPopScope(
        onWillPop: () async {
          for (ExpandableController item in _listControllers!) {
            item.removeListener(() {});
          }

          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(
              'Choose your Time',
              style: TextStyle(color: kWhiteColor),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 50,
                child: SingleChildScrollView(
                  child: SizedBox(
                    child: Column(
                      children: [
                        ...List.generate(
                          3,
                          (index) {
                            if (_listControllers![index].value) {
                              _closeExpanded(index);
                            }
                            return BlocConsumer<AppointmentsBloc,
                                AppointmentsState>(
                              buildWhen: (previous, current) {
                                if (current is ChooseIntervalState) return true;
                                if (current is DataSuccess) return true;
                                if (current is DataError) return true;
                                if (current is DataLoading) return true;
                                return false;
                              },
                              listener: (context, state) async {
                                if (state is ChangeExpandState) {
                                  _closeExpanded(state.index);
                                } else if (state is DataLoading) {
                                } else if (state is DataError) {
                                  print('error state');
                                  print(_errorShow);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('${state.message}')));
                                } else if (state is DataSuccess) {
                                  for (List<ActiveInterval> interval
                                      in intervals) {
                                    print(interval);

                                    interval.firstWhere((a) {
                                      print('A data is ' + a.day);
                                      print(
                                          'A data is ' + _activeInterval!.day);
                                      return a == _activeInterval;
                                    })
                                      ..state = true;
                                  }
                                  if (state is PostDataSuccessState) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text('Done')));
                                  } // if (_errorShow || _loadingShow) {

                                }
                              },
                              builder: (context, state) =>
                                  _buildExpandableNotifier(
                                      index, context, state),
                            );
                          },
                        ),
                        VerticalSpacing(of: 60),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: getProportionateScreenHeight(40),
                right: kDefaultPadding,
                left: kDefaultPadding,
                child: Container(
                  child: CustomButton(
                    onPressed: _reserveData,
                    child: Text(
                      'Follow up on reservation',
                      style: TextStyle(color: kWhiteColor, fontSize: 16),
                    ),
                    color: kPrimaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<ActiveInterval> getTime(String start, String end, int duration,
      List<String> intervals, String date) {
    if (start.isEmpty && end.isEmpty) {
      return [];
    }
    List<ActiveInterval> list = [];

    var split = end.split(':');
    int eMin = int.parse(split[1]) + (int.parse(split[0]) * 60);

    var split2 = start.split(':');
    int sMin = int.parse(split2[1]) + (int.parse(split2[0]) * 60);

    String newTime = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(
            sMin.floor() * 60000 - 60 * 60 * 2 * 1000));
    int tMin = sMin;
    while (tMin < eMin) {
      bool isContain = intervals.contains(newTime.substring(0, 5));
      list.add(ActiveInterval(newTime, isContain)..date = date);
      tMin += duration;
      print(tMin);

      newTime = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              tMin.floor() * 60000 - 60 * 60 * 2 * 1000));
    }
    print('done');
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    _listControllers = List.generate(
        3,
        (index) =>
            ExpandableController()..expanded = this.widget.index == index);
    _initialInterval();
    super.initState();
  }

  ExpandableNotifier _buildExpandableNotifier(
      int index, BuildContext context, AppointmentsState state) {
    return ExpandableNotifier(
      child: Card(
        child: ExpandablePanel(
          controller: _listControllers![index]
            ..addListener(() {
              if (_listControllers![index].value) {
                BlocProvider.of<AppointmentsBloc>(context)
                    .add(ChangeExpand(index));
              }
            }),
          key: UniqueKey(),
          theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapHeaderToExpand: true,
              iconPlacement: ExpandablePanelIconPlacement.left),
          header: Row(
            children: [
              Spacer(),
              Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      widget.listAppoints![index].day ?? '',
                      style: Theme.of(context).textTheme.body2,
                    )),
              ),
              Spacer(),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          collapsed: SizedBox.shrink(),
          expanded: Container(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: intervals[index].length,
              itemBuilder: (context, i) {
                var cInterval = intervals[index][i];
                return SizedBox(
                  height: 10,
                  child: OutlinedButton(
                    onPressed: cInterval.state
                        ? null
                        : () {
                            context
                                .read<AppointmentsBloc>()
                                .add(ChooseIntervalEvent(cInterval));
                          },
                    child: Text(
                      cInterval.interval ?? '',
                      style: TextStyle(
                          decoration: cInterval.state
                              ? TextDecoration.lineThrough
                              : null,
                          color: cInterval.state ? kGreyColor : null),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: _checkIndexSelect(state, cInterval)
                            ? kPrimaryColor
                            : null,
                        primary: _checkIndexSelect(state, cInterval)
                            ? kWhiteColor
                            : null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 30,
                  mainAxisSpacing: 16),
            ),
          ),
        ),
      ),
    );
  }

  _checkIndexSelect(state, ActiveInterval interval) {
    if (state is ChooseIntervalState && state.interval == interval) {
      print('equal');
      _activeInterval = state.interval;
      return true;
    }
    return false;
  }

  _closeExpanded(int index) {
    if (index == 0) {
      _listControllers?[1].value = false;
      _listControllers?[2].value = false;
    } else if (index == 1) {
      _listControllers?[0].value = false;
      _listControllers?[2].value = false;
    }
    if (index == 2) {
      _listControllers?[0].value = false;
      _listControllers?[1].value = false;
    }
  }

  void _initialInterval() {
    intervals = List.generate(3, (index) {
      var cTable = widget.listAppoints![index].table;
      return getTime(
          (cTable?.sTimeWOut ?? ''),
          (cTable?.eTimeWOut ?? ''),
          widget.doctor?.durationMin ?? 100,
          widget.listAppoints?[index].busyInterval ?? [],
          widget.listAppoints![index].day!);
    }).toList();
  }

  _reserveData() {
    var appoint = context.read<AppointmentsBloc>();
    String token = Hive.box('user_data').get('token') ?? '';
    if (_activeInterval == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              alignment: Alignment.center,
              child: Text("Select item first"))));
      return;
    }
    print(_activeInterval!.date.substring(4));
    print(_activeInterval!.day);
    print(_activeInterval!.interval);
    //
    appoint.add(CommitIntervalEvent(
      token,
      Reserve(
          doctorEmail: widget.doctor?.email,
          date: _activeInterval!.date.substring(4),
          day: _activeInterval!.day,
          interval: _activeInterval!.interval!.substring(0, 5),
          state: 0),
    ));
  }
}
