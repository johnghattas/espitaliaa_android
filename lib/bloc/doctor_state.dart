part of 'doctor_bloc.dart';

@immutable
abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class LoadingData extends DoctorState {}

class FetchingMore extends DoctorState {}
class EndFetching extends DoctorState {}

class FetchedData extends DoctorState {
  final List<Doctor>? doctors;

  FetchedData({required this.doctors});

}

class LoadedData extends DoctorState {
  final List<Doctor> doctors;

  LoadedData({required this.doctors});
}
class ErrorFetch extends DoctorState {
  final String? message;

  ErrorFetch({ this.message});
}



