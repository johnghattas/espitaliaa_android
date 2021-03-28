part of 'appointments_bloc.dart';

@immutable
abstract class AppointmentsEvent {}

class GetData extends AppointmentsEvent {}

class GetMoreData extends AppointmentsEvent {}

class GetPreviousData extends AppointmentsEvent {}

class GoNextData extends AppointmentsEvent {}

class ChangeExpand extends AppointmentsEvent {
  final int index;

  ChangeExpand(this.index);
}

class ChooseIntervalEvent extends AppointmentsEvent {
  final ActiveInterval interval;

  ChooseIntervalEvent(this.interval);
}

class CommitIntervalEvent extends AppointmentsEvent {
  final String token;
  final Reserve reserve;

  CommitIntervalEvent(this.token, this.reserve);
}
