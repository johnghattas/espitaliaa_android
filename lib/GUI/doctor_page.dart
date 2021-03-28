import 'package:espitalia/bloc/appointments_bloc.dart';
import 'package:espitalia/bloc/doctor_bloc.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:espitalia/widget/appointmet_card.dart';
import 'package:espitalia/widget/temp_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorPage extends StatefulWidget {
  final String email;

  const DoctorPage({Key? key, required this.email}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  List<Appointment> _appointments = [];
  final double cHeight = 60.0;
  final _scaffold = GlobalKey<ScaffoldState>();

  Doctor? _doctor;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
      child: Scaffold(
        key: _scaffold,
        extendBody: true,
        appBar: AppBar(

          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
            buildWhen: (previous, current) {
              // print(!(current is ChangeExpandState));
              if (current is ChangeExpandState) return false;

              return true;
            },
            listener: (context, state) {
              if (state is PostDataSuccessState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      backgroundColor: Colors.green, content: Text('Done')));
              }
              if (state is DataError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('${state.message}')));
              }
            },
            builder: (context, state) {
              if (state is LoadingData) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DataError && _appointments.isEmpty) {
                context.read<AppointmentsBloc>().isFetching = false;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<AppointmentsBloc>(context)
                            ..isFetching = true
                            ..add(GetData());
                        },
                        icon: Icon(Icons.refresh),
                      ),
                      const SizedBox(height: 15),
                      Text(state.message, textAlign: TextAlign.center),
                    ],
                  ),
                );
              } else if (state is DataSuccess) {
                this._doctor = state.doctorInfo?.doctor;
                this._appointments = state.doctorInfo?.appointments ?? [];
              } else if (state is FetchMoreApoSuccess) {
                this._appointments.addAll(state.appointments);
              }

              return Column(
                children: [
                  Container(
                    height: cHeight + 15,
                    child: Stack(
                      children: [
                        Container(
                          color: kPrimaryColor,
                          height: cHeight,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: cHeight + 10,
                            width: cHeight + 10,
                            child: CircleAvatar(
                              child: Image.asset(
                                'assets/espitalia.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalSpacing(of: kDefaultPadding),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: {
                            0: FractionColumnWidth(0.1),
                            1: FractionColumnWidth(0.8),
                            2: FractionColumnWidth(0.1),
                          },
                          children: [
                            TableRow(
                              children: [
                                SizedBox.shrink(),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _doctor?.name ?? '',
                                      style: kStyleM.copyWith(fontSize: kMediumSize),
                                    )),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    CupertinoIcons.heart,
                                    color: kBlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            'specialist',
                            style: TextStyle(fontSize: kSmallSize),
                          ),
                        ),
                        VerticalSpacing(of: kDefaultPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TemplateCard(
                              icon: Icons.remove_red_eye,
                              text: 'Views',
                              subText: "250",
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            TemplateCard(
                              icon: CupertinoIcons.flag,
                              text: 'Detection price',
                              subText: "0LE",
                            ),
                          ],
                        ),
                        VerticalSpacing(of: 10),
                        Appointments(
                          // confirmPressed: ()=>_reserveData(context, ActivateAction().),
                          scaffold: _scaffold,
                          doctor: _doctor,
                          appointments: _appointments,
                          onPressed: () {},
                          onTapNext: () {
                            var appoint = context.read<AppointmentsBloc>();
                            if (appoint.page > appoint.currentPage) {
                              appoint..add(GoNextData());
                              return;
                            }
                            appoint
                              ..add(GetMoreData())
                              ..isFetching = true;
                          },
                          onTapPrevious: () {
                            context.read<AppointmentsBloc>()
                              ..add(GetPreviousData());
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _doctor = null;

    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _doctor = null;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.email);
    AppointmentsBloc.email = widget.email;
    super.initState();
    context.read<AppointmentsBloc>().add(GetData());
  }
}
