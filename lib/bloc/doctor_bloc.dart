import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/repositers/doctors_repo.dart';
import 'package:meta/meta.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorRepo doctorRepo;

  DoctorBloc({required this.doctorRepo}) : super(DoctorInitial());

  int page = 1;
  bool isFetching = false;
  // late List<Doctor> doctors;

  @override
  Stream<DoctorState> mapEventToState(
    DoctorEvent event,
  ) async* {
    if(event is GetDoctors){
      yield LoadingData();
      try {
        List<Doctor> doctors =  await doctorRepo.getAllDoctors(page: page);
        yield LoadedData(doctors: doctors);
        page++;
      } catch (e) {
        yield ErrorFetch(message: e.toString());
        print(e);
      }
    }else if(event is MoreDoctors){
      yield FetchingMore();
      try {
        final List<Doctor> array = await doctorRepo.getAllDoctors(page: page);
        if(array.length > 0) {
          // List<Doctor> doctors doctors.addAll(array);
          //
          yield FetchedData(doctors: array);
          page++;
        }else
        yield EndFetching();

      } catch (e) {
        yield ErrorFetch(message: e.toString());
        print(e);
      }


    }
  }
}
