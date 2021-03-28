import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String? email;
  @HiveField(1)
  String? phone;
  @HiveField(2)
  String? name;
  @HiveField(3)
  bool? isDoctor = false;

  User({
    @required this.email,
    @required this.phone,
    @required this.name,
    this.isDoctor,
  });

  User.fromMap(Map map, bool doctor) {
    this.email = map['email'];
    this.phone = map['phone'];
    this.name = map['name'];
    this.isDoctor = map['is_owner'] == doctor;
  }

  Map toMap() {
    return {
      'email': this.email,
      'phone': this.phone,
      'name': this.name,
      'is_owner': this.isDoctor! ? "1" : "0",
    };
  }

// get name => '$firstName $lastName';

}
