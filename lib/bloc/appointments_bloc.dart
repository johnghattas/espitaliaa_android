import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:espitalia/GUI/choose_your_time_page.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/models/reserve_model.dart';
import 'package:espitalia/repositers/doctor_info_repo.dart';
import 'package:meta/meta.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  DoctorInfoRepo doctorInfoRepo;

  static String? email;

  AppointmentsBloc({required this.doctorInfoRepo})
      : super(AppointmentsInitial());

  bool isFetching = false;
  int page = 1;
  int currentPage = 1;

  ActiveInterval? activeInterval;

  @override
  Stream<AppointmentsState> mapEventToState(
    AppointmentsEvent event,
  ) async* {
    if (event is GetData) {
      yield DataLoading();
      try {
        page = 1;
        currentPage = 1;
        var doctors =
            await doctorInfoRepo.getDoctorInfo(email ?? '', page: page);
        yield DataSuccess(doctorInfo: doctors);
        page++;
        currentPage++;
      } catch (e) {
        yield DataError(message: e.toString());
        print('this' + e.toString());
      }
    } else if (event is GetMoreData) {
      yield LoadingFetching();
      try {
        var appointments =
            await doctorInfoRepo.getDoctorInfo(email ?? '', page: page);
        yield FetchMoreApoSuccess(appointments: appointments);
        page++;
        currentPage++;
      } catch (e) {
        yield DataError(message: e.toString());
        print(e);
      }
    } else if (event is GetPreviousData && currentPage > 2) {
      yield PreviousPage(page: --currentPage - 1);
    } else if (event is GoNextData && currentPage <= page) {
      yield NextPage(page: ++currentPage - 1);
    } else if (event is ChangeExpand) {
      yield ChangeExpandState(index: event.index);
    } else if (event is ChooseIntervalEvent) {
      activeInterval = event.interval;
      yield ChooseIntervalState(interval: activeInterval!);
    } else if (event is CommitIntervalEvent) {
      yield DataLoading();
      try {
        bool ret = await doctorInfoRepo.setInterval(event.token, event.reserve);

        if (ret) {
          yield PostDataSuccessState();
        } else
          yield DataError(message: 'un expected Error');
      } catch (e) {
        yield DataError(message: e.toString());

        print(e);
      }
    }
  }
}
