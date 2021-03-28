import 'package:espitalia/bloc/doctor_bloc.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/repositers/doctors_repo.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:espitalia/widget/bar_with_search.dart';
import 'package:espitalia/widget/card_doctor_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  late ScrollController _scrollController;

  List<Doctor> _doctors = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Theme(
      data: ThemeData(
        accentColor: kPrimaryColor,
        primaryColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
          iconTheme: IconThemeData(color: kWhiteColor)
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocProvider<DoctorBloc>(
            create: (context) =>
                DoctorBloc(doctorRepo: DoctorRepo())..add(GetDoctors()),
            child: Column(
              children: [
                BarWithSearch(
                  text: 'Choose a doctor and book now',
                  hintText: 'Search by the name of the doctor',
                  isHasFilter: true,
                ),
                VerticalSpacing(of: 10),
                Expanded(
                  child: BlocConsumer<DoctorBloc, DoctorState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      Widget? cChild = _handleState(context, state);
                      if( cChild != null) {
                        return cChild;
                      }
                      return ListView(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.position.extentAfter < 500 &&
                                !context.read<DoctorBloc>().isFetching) {
                              context.read<DoctorBloc>()
                                ..add(MoreDoctors())
                                ..isFetching = true;
                            }
                          }),
                        children: [
                          ...List.generate(
                            _doctors.length,
                            (index) => CardDoctorItem(
                              doctor: _doctors[index],
                              onPressed: () => Navigator.pushNamed(
                                  context, 'doctor',
                                  arguments: {'email': _doctors[index].email}),
                            ),
                          ),
                          (state is FetchingMore)
                              ? AnimatedContainer(
                                  height: 200,
                                  width: double.infinity,
                                  duration: Duration(milliseconds: 500),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  Widget? _handleState(BuildContext context, DoctorState state) {
    if (state is LoadedData) {
      _doctors = state.doctors;
      context.read<DoctorBloc>().isFetching = false;
    } else if (state is FetchedData) {
      _doctors.addAll(state.doctors ?? []);
      context.read<DoctorBloc>().isFetching = false;
    } else if (state is LoadingData) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ErrorFetch && _doctors.isEmpty) {
      context.read<DoctorBloc>().isFetching = false;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              BlocProvider.of<DoctorBloc>(context)
                ..isFetching = true
                ..add(GetDoctors());
            },
            icon: Icon(Icons.refresh),
          ),
          const SizedBox(height: 15),
          Text(state.message ?? '', textAlign: TextAlign.center),
        ],
      );
    }

  }
}
