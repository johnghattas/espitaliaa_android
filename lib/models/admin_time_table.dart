import 'package:espitalia/models/Doctor.dart' show TimeTable;

class AdminTimeTable {
  bool isFirstCome;
  int? durationMin;
  List<TimeTable>? timeTables;

  AdminTimeTable({this.isFirstCome = false, this.durationMin, this.timeTables});

  factory AdminTimeTable.fromJson(Map<String, dynamic> json) {
    return AdminTimeTable(
      durationMin: json['duration_min'],
      isFirstCome: json['is_first_come'] == 1,
      timeTables:
          (json['tables'] as List).map((e) => TimeTable.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableList'] = this.timeTables?.map((e) => e.toJson()).toList();
    data['is_first_come'] = this.isFirstCome;
    data['duration_min'] = this.durationMin;
    print(data['duration_min']);

    return data;
  }
}
