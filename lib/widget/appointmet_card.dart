import 'package:espitalia/GUI/choose_your_time_page.dart';
import 'package:espitalia/bloc/appointments_bloc.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/models/reserve_model.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../constant.dart';

class AppointItem extends StatelessWidget {
  final String? day;
  final TimeTable? timeTable;
  final VoidCallback? onPressed;

  const AppointItem({
    Key? key,
    required this.timeTable,
    this.onPressed,
    this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(90),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            color: kPrimaryColor.withOpacity(0.07),
            child: Text(
              day ?? '',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                (timeTable?.isAvail ?? false)
                    ? '${timeTable?.startTime}\nTo\n${timeTable?.endTime}'
                    : 'No Available Dates',
                textAlign: TextAlign.center,
                style: (timeTable?.isAvail ?? false)
                    ? TextStyle(height: 1.75, fontWeight: FontWeight.bold)
                    : null,
              ),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(80),
            height: 30,
            child: ElevatedButton(
              onPressed: (timeTable?.isAvail ?? false) ? onPressed : null,
              child: Text('Book'),
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: kPrimaryColor,
                  onPrimary: Colors.white,
                  onSurface: kPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 1)),
            ),
          )
        ],
      ),
    );
  }
}

class Appointments extends StatefulWidget {
  final List<Appointment>? appointments;
  final Doctor? doctor;
  final VoidCallback? onPressed;
  final VoidCallback? onTapPrevious;
  final VoidCallback? onTapNext;
  final GlobalKey<ScaffoldState>? scaffold;


  const Appointments({
    Key? key,
    this.appointments,
    this.onPressed,
    this.onTapPrevious,
    this.onTapNext,
    this.doctor,
    this.scaffold,
  }) : super(key: key);

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int _page = 1;
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    this._page = context.read<AppointmentsBloc>().currentPage;

    // this._page = context.read<AppointmentsBloc>().page;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Book from your place and pay when the clinic arrives',
              style:
                  kStyle.copyWith(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            Center(
              child: Text(
                'you will be directed to the  clinic through the map',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            VerticalSpacing(
              of: 15,
            ),
            Container(
              height: getProportionateScreenHeight(160),
              child: Row(
                children: [
                  InkWell(
                      onTap: widget.onTapPrevious,
                      child: Icon(
                        Icons.arrow_left,
                        color: kPrimaryColor,
                        size: 28,
                      )),
                  Expanded(
                    child: BlocListener<AppointmentsBloc, AppointmentsState>(
                      listener: (context, state) {
                        if (state is GetData) {
                          _page = 1;
                        }
                        if (state is FetchMoreApoSuccess) {
                          _pageController.animateToPage(_page - 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        } else if (state is PreviousPage) {
                          _pageController.jumpToPage(state.page - 1);
                        } else if (state is NextPage) {
                          _pageController.animateToPage(state.page - 1,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.ease);
                        }
                      },
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        physics: new NeverScrollableScrollPhysics(),
                        children: List.generate((this._page - 1), (index) {
                          print(this._page);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...List.generate(
                                3,
                                (i) {
                                  var mi = (index) * 3 + i;

                                  if ((mi) >=
                                      (widget.appointments?.length ?? 0)) {
                                    return Container();
                                  }
                                  return AppointItem(
                                    day: widget.appointments?[mi].shortDay,
                                    timeTable: widget.appointments?[mi].table,
                                    onPressed: () => _onPressedApp(
                                        date: widget.appointments?[mi].day
                                        ,
                                        scaffold: widget.scaffold,
                                        appointments: widget.appointments
                                            ?.sublist(
                                                (index) * 3, (index) * 3 + 3),
                                        index: i),
                                  );
                                },
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                !(context.watch<AppointmentsBloc>().state is LoadingFetching)?
                  InkWell(
                      onTap: widget.onTapNext,
                      child: Icon(
                        Icons.arrow_right,
                        size: 28,
                        color: kPrimaryColor,
                      )): Center(child: SizedBox(height: 20 , width: 20,child: CircularProgressIndicator(strokeWidth: 2,))),
                ],
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
  }

  Widget _conformWidget(String date) {
    print('confirm date'+date.toString());
    return Container(
      color: kWhiteColor,
      height: 200,
      width: double.infinity,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          SizedBox(width: 120,child: Divider(height: 2,thickness: 4,color: kGreyColor[400],)),
          Spacer(),
          Container(
            child: ElevatedButton(
                onPressed: () =>
                    _reserveData(context, ActiveInterval.init(date: date)),
                child: Text(
                  'Confirm Reservation',
                  style: TextStyle(color: kWhiteColor),
                )),

          ),
          Spacer(),

        ],
      ),
    );
  }

  void _onPressedApp(
      {GlobalKey<ScaffoldState>? scaffold,
      String? date,
      required List<Appointment>? appointments,
      required int index}) {
    if ((widget.doctor?.isFirstCome ?? false)) {
      //push to confirm reservation page
      print('this day is '+ (appointments?[index].day??''));
      if (scaffold != null && date != null) {
        scaffold.currentState
            ?.showBottomSheet((context) => _conformWidget(appointments?[index].day??''));
      }
    } else {
      //push to choose time page with busy intervals
      Navigator.pushNamed(context, 'chooseTime', arguments: {
        'appointments': appointments,
        'index': index,
        'doctor': widget.doctor
      });
    }
  }

  _reserveData(BuildContext context, ActiveInterval activeInterval) {
    var appoint = context.read<AppointmentsBloc>();
    String token = Hive.box('user_data').get('token')??'';

    print(activeInterval.date);
    appoint.add(CommitIntervalEvent(
      token,
      Reserve(
          doctorEmail: widget.doctor?.email,
          date: activeInterval.date.substring(4),
          day: activeInterval.day.substring(0,3),
          state: 0),
    ));
  }
}
