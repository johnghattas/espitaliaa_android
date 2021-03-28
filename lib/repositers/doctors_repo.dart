import 'dart:convert';

import 'package:espitalia/constant_api.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:http/http.dart';

class DoctorRepo {
  static final DoctorRepo _doctorRepo = DoctorRepo._();

  DoctorRepo._();

  factory DoctorRepo() => _doctorRepo;

  Future<List<Doctor>> getAllDoctors({required int page}) async {
    print('this');
    //Uri.parse('https://esitaliaaherko.herokuapp.com/api/getDoctors?page=$page',)
    Response response = await get(
        Uri.https(cUrl, 'api/getDoctors', {'page': page.toString()}),
        headers: {
          'accept': 'application/json',
        });

    Map<String, dynamic> map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(map['data']);
      List<dynamic> data = map['data']['data'];
      print('done');

      List<Doctor> doctors =
          data.map<Doctor>((value) => Doctor.fromJson(value)).toList();

      return doctors;
    } else {
      throw Exception('Cant\'t load data');
    }
  }
}
