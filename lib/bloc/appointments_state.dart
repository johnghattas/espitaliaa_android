part of 'appointments_bloc.dart';

@immutable
abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class DataLoading extends AppointmentsState {}

class DataSuccess extends AppointmentsState {
  final DoctorInfo? doctorInfo;

  DataSuccess({this.doctorInfo});
}

class FetchMoreApoSuccess extends AppointmentsState {
  final List<Appointment> appointments;

  FetchMoreApoSuccess({required this.appointments});
}

class PreviousPage extends AppointmentsState {
  final int page;

  PreviousPage({required this.page});
}

class NextPage extends AppointmentsState {
  final int page;

  NextPage({required this.page});
}

class LoadNextPageState extends AppointmentsState {

  LoadNextPageState();
}

class LoadingFetching extends AppointmentsState {}

class DataError extends AppointmentsState {
  final String message;

  DataError({required this.message});
}

class ChangeExpandState extends AppointmentsState {
  final int index;

  ChangeExpandState({required this.index});
}

class ChooseIntervalState extends AppointmentsState {
  final ActiveInterval interval;

  ChooseIntervalState({required this.interval});
}

class PostDataSuccessState extends AppointmentsState {

  PostDataSuccessState();
}