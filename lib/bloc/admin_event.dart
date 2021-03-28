part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class ChangeCheckboxEvent extends AdminEvent {}
class ChangeDropEvent extends AdminEvent {
  final String method;

  ChangeDropEvent(this.method);
}

class GetTablesEvent extends AdminEvent {
  final String token;

  GetTablesEvent(this.token);
}


class EditTablesEvent extends AdminEvent {
  final String token;
  final AdminTimeTable timeTable;

  EditTablesEvent(this.token, this.timeTable);
}
