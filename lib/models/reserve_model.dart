
class Reserve{

  String? doctorEmail;
  String? date;
  String? day;
  String? interval;
  int? state;

  Reserve(
  {this.doctorEmail, this.date, this.day, this.interval, this.state});

  Reserve.fromJson(Map<String, dynamic> json) {
  doctorEmail = json['doctor_email'];
  date = json['date'];
  day = json['day'];
  interval = json['interval'];
  state = json['state'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['doctor_email'] = this.doctorEmail;
  data['date'] = this.date;
  data['day'] = this.day;
  data['interval'] = this.interval??'00:00';
  data['state'] = this.state.toString();
  return data;
  }

}