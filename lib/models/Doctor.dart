import 'package:intl/intl.dart';

class Appointment {
  String? _day;
  List<String>? busyInterval;
  TimeTable? table;

  Appointment.fromJson(MapEntry<String, dynamic> json) {
    _day = json.key;
    print(json.value['intervals']);

    busyInterval = (json.value['intervals'] as List).cast<String>();
    print(busyInterval);

    table = TimeTable.fromJson(json.value['table']);
    print('dfsdfsdfooooooooooooon');
  }

  String get date {
    var lowerCase = _day?.toLowerCase();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (lowerCase == 'today') {
      return DateFormat('dd/MM/yyyy').format(now);
    }
    if (lowerCase == 'tomorrow') {
      return DateFormat('dd/MM/yyyy').format(tomorrow);
    } else
      return _day?.split(' ').last ?? '';
  }

  String? get day {
    var lowerCase = _day?.toLowerCase();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (lowerCase == 'today') {
      return DateFormat('EE').format(now) +
          ' ' +
          DateFormat('dd/MM/yyyy').format(now);
    }
    if (lowerCase == 'tomorrow') {
      return DateFormat('EE').format(tomorrow) +
          ' ' +
          DateFormat('dd/MM/yyyy').format(tomorrow);
    } else
      return _day;
  }

  set day(value) => this._day;

  String get shortDay => ((_day?.indexOf('/') ?? -1) != -1)
      ? ((_day?.substring(0, (_day?.lastIndexOf('/')))) ?? '')
      : _day ?? '';
}

class Doctor {
  int? durationMin;
  String email;
  bool? isFirstCome;
  String name;
  String phone;
  String spatial;

  Doctor(
      {this.durationMin,
      this.email = '',
      this.isFirstCome,
      this.name = '',
      this.phone = '',
      this.spatial = ''});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      durationMin: json['duration_min'],
      email: json['email'],
      isFirstCome: json['is_first_come'] == 1,
      name: json['name'],
      phone: json['phone'],
      spatial: json['spatial'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['is_first_come'] = this.isFirstCome;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['spatial'] = this.spatial;
    if (this.durationMin != null) {
      data['duration_min'] = this.durationMin;
    }
    return data;
  }
}

class DoctorInfo {
  Doctor? doctor;
  List<Appointment>? appointments;

  DoctorInfo({
    required this.doctor,
    required this.appointments,
  });

  DoctorInfo.fromJson(Map<String, dynamic> json) {
    doctor = Doctor.fromJson(json['info']);
    Map<String, dynamic> days = json['days'];
    print(days.entries);

    appointments = days.entries.map((value) {
      print(value);

      return Appointment.fromJson(value);
    }).toList();
    print('dooooooooooooon');
  }
}

class TimeTable {
  int? id;
  String? day;
  bool? isAvail;
  String? sTimeWOut;
  String? eTimeWOut;
  int? countAtt;

  TimeTable({
    required this.id,
    required this.day,
    required this.isAvail,
    required startTime,
    required endTime,
    this.countAtt,
  })  : this.sTimeWOut = startTime,
        this.eTimeWOut = endTime;

  TimeTable.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'];
    day = json['day'];
    isAvail = json['is_avail'] == 1 ? true : false;
    sTimeWOut = json['start_time'];
    eTimeWOut = json['end_time'];
    countAtt = json['count_att'];
  }

  TimeTable.init();

  String get endTime => _handleTime(this.eTimeWOut);

  set endTime(value) {
    int hours = int.parse(value.split(':')[0]);
    int min = int.parse(value.split(':')[1].substring(0, 2));
    String fun = value.split(':')[1].substring(2).trimLeft();

    if (fun.toLowerCase() == 'am')
      eTimeWOut =
          '${hours.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    else
      eTimeWOut = '${hours + 12}:${min.toString().padLeft(2, '0')}';
  }

  String get startTime => _handleTime(this.sTimeWOut);

  set startTime(String value) {
    int hours = int.parse(value.split(':')[0]);
    int min = int.parse(value.split(':')[1].substring(0, 2));
    String fun = value.split(':')[1].substring(2).trimLeft();

    print(fun);

    if (fun.toLowerCase() == 'am')
      sTimeWOut =
          '${hours.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    else
      sTimeWOut = '${hours + 12}:${min.toString().padLeft(2, '0')}';

    print(sTimeWOut);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['is_avail'] = (this.isAvail ?? false) ? 1 : 0;
    data['start_time'] =
        (this.isAvail ?? false) ? this.sTimeWOut ?? '00:00' : '00:00';
    data['end_time'] =
        (this.isAvail ?? false) ? this.eTimeWOut ?? '00:00' : '00:00';
    data['count_att'] = this.countAtt ?? 0;
    return data;
  }

  String _handleTime(String? time) {
    if (time == null) {
      return '';
    }
    var value = time.split(':');
    int hours = int.parse(value[0]);
    return hours >= 12
        ? '${time.replaceFirst(hours.toString(), (hours - 12).toString().padLeft(2, '0'))} PM'
        : '$time AM';
  }
}
