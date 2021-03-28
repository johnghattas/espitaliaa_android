import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:espitalia/models/admin_time_table.dart';
import 'package:espitalia/repositers/admin_repo.dart';
import 'package:meta/meta.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc({required this.adminRepo}) : super(AdminInitial());
  AdminRepo adminRepo;

  @override
  Stream<AdminState> mapEventToState(
    AdminEvent event,
  ) async* {
    if (event is ChangeCheckboxEvent) {
      yield ChangeCheckboxState();
    }
    if (event is ChangeDropEvent) {
      yield ChangeDropState(event.method);
    }

    if (event is GetTablesEvent) {
      yield LoadingGetTablesState();
      try {
        AdminTimeTable timeTable = await adminRepo.getDoctorTables(event.token);
        yield GetTableState(timeTable);
      } catch (e) {
        print(e);
        yield ErrorGetTablesState(e.toString());
      }
    }

    if (event is EditTablesEvent) {
      yield LoadingGetTablesState();
      try {
        bool val =
            await adminRepo.editDoctorTable(event.token, event.timeTable);

        if (val) {
          yield EditTablesSuccessState();
        }
      } on Exception catch (e) {
        yield ErrorGetTablesState(e.toString());
      }
    }
  }
}
