import 'dart:convert';

import 'package:espitalia/constant_api.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/models/reserve_model.dart';
import 'package:http/http.dart';

class DoctorInfoRepo {
  static final DoctorInfoRepo _doctorInfoRepo = DoctorInfoRepo._();

  DoctorInfoRepo._();

  factory DoctorInfoRepo() => _doctorInfoRepo;

  Future<bool> setInterval(String token, Reserve reserve) async {
    Response response = await post(
        Uri.https(
            cUrl, 'api/patient/reserve'),
        headers: {
          'accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },body: reserve.toJson());

      final Map map = jsonDecode(response.body);
      print(map);
      if(response.statusCode == 401){
        throw Exception('Un Authorized');

      }

    if(response.statusCode == 200) {

      if(map['data'] != null){
        return true;
      }
    }else{
      if(map.containsKey('error') && response.statusCode == 400)
        throw Exception(map['error']);
      throw Exception('Error when put the data');

    }
    return false;

}

  Future<dynamic> getDoctorInfo(String email, {required int page}) async {

    Response response = await get(
        Uri.https(
            cUrl, 'api/showDisap/$email', {'page': page.toString()}),
        headers: {
          'accept': 'application/json',
        });
    if(response.statusCode == 401){
      throw Exception('Un Authorized');

    }

    Map<String, dynamic> map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = map['data'];

      if (data.containsKey('info')) {
        DoctorInfo doctor = DoctorInfo.fromJson(data);

        return doctor;
      } else {

        List<Appointment> app = data['days'].entries.map((value) {

          return Appointment.fromJson(value);
        }).toList().cast<Appointment>();

        return app;
      }
    } else {
      throw Exception('Cant\'t load data');
    }
  }
}
