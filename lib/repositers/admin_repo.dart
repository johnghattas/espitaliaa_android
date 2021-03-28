import 'dart:convert';

import 'package:espitalia/models/admin_time_table.dart';
import 'package:http/http.dart';

import '../constant_api.dart';

class AdminRepo {
  Future<AdminTimeTable> getDoctorTables(
    String token,
  ) async {
    Response response = await get(Uri.https(cUrl, 'api/doctor/tables'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 401) {
      throw Exception('Un Authorized');
    }

    Map map = jsonDecode(response.body);
    print(map);

    if (response.statusCode == 200) {
      return AdminTimeTable.fromJson(map['data']);
    } else {
      if (response.statusCode == 400) {
        throw Exception(map['error']);
      }

      throw Exception('Un handled exception');
    }
  }

  Future<bool> editDoctorTable(String token, AdminTimeTable tables) async {
    print('this is the duration ${tables.durationMin}');
    Response response = await patch(Uri.https(cUrl, 'api/doctor/appoints'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(tables.toJson()));

    if (response.statusCode == 401) {
      throw Exception('Un Authorized');
    }

    Map map = jsonDecode(response.body);
    print(map);
    if (response.statusCode == 200) {
      return true;
    } else {
      if (response.statusCode == 400) {
        throw Exception(map['error']);
      } else if (map.containsKey('message') &&
          (map['message'] as String).contains(RegExp('[invalid][given]'))) {
        throw Exception('start time > end time');

      }

      throw Exception('Un handled exception');
    }
  }
}
