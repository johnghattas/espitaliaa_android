part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}
class ChangeCheckboxState extends AdminState {}
class ChangeDropState extends AdminState {
  final String method;

  ChangeDropState(this.method);
}


class GetTableState extends AdminState {
  final AdminTimeTable adminTimeTable;

  GetTableState(this.adminTimeTable);


}

class EditTablesSuccessState extends AdminState {}
class LoadingGetTablesState extends AdminState {}
class ErrorGetTablesState extends AdminState {
  final String message;

  ErrorGetTablesState(this.message);
}

