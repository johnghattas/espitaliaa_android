import 'dart:convert';

import 'package:espitalia/models/user_model.dart';
import 'package:http/http.dart';

import '../constant_api.dart';

abstract class AuthServices {
  Future? getUser(String token);

  Future signIn({
    required String email,
    required String password,
    required bool isOwner,
  });

  Future signOut(String token);

  Future<String?> signUp({required User user, required String password});
}

class SignInServices extends AuthServices {
  static final SignInServices _doctorRepo = SignInServices._();

  SignInServices._();

  factory SignInServices() => _doctorRepo;

  static String _user = 'user';

  set user(bool value) => _user = (value ? 'doctor' : 'user');

  bool get userFunction => _user == 'doctor';

  @override
  Future? getUser(String token) async {
    print('token' + token);

    Response response = await get(Uri.https('$cUrl', 'api/$_user/auth/me'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    Map? map = _checkResponse(response);
    print('get user map is' + map.toString());

    if (map != null) {
      return User.fromMap(map, userFunction);
    }

    return null;
  }

  @override
  Future<String> signIn(
      {required String email,
      required String password,
      required bool isOwner}) async {
    assert(email.isNotEmpty);
    assert(password.isNotEmpty);

    Response response =
        await post(Uri.https('$cUrl', 'api/$_user/auth/login'), body: {
      'email': email,
      'password': password,
    }, headers: {
      'accept': 'application/json'
    });
    print('this');

    Map? map = _checkResponse(response);
    print(map);

    if (map == null) {
      return '';
    }

    if (map.containsKey('message')) {
      print(map['message']);

      return '';
    }

    if (map.containsKey('access_token')) {
      return map['access_token'].toString();
    } else {
      throw Exception('');
    }

  }

  @override
  Future signOut(String token) async {
    assert(token.isNotEmpty);

    Response response = await post(
      Uri(path: '$cUrl/$_user/auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    Map? map = _checkResponse(response);

    if (map != null && map['message'] == 'Successfully logged out') {
      return map['message'];
    }

    return null;
  }

  @override
  Future<String?> signUp({required User user, required String password}) async {
    Response response =
        await post(Uri.https('$cUrl', 'api/$_user/auth/register'), body: {
      ...user.toMap(),
      'password': password,
      'password_confirmation': password,
          'spatial':'Doctor'
    }, headers: {
      'accept': 'application/json'
    });

    Map? map = _checkResponse(response);
    print(map);

    if (map != null && map.containsKey('access_token')) {
      return map['access_token'];
    }

    if (map!.containsKey('errors')) {
      throw Exception(((map['errors'] as Map).values).toString());
    }

    return '';
  }

  Map? _checkResponse(Response response) {
    if (response.statusCode == 401) {
      print('un auth');
      throw Exception('un authentication');
    }

    Map map = jsonDecode(response.body);
    print(map);

    if (map.containsKey('access_token')) {
      // _context.read<LoadingAndErrorProvider>().changeState(LoadingErrorState.DONE);

    }
    if (map.containsKey('token')) {
      // _context.read<LoadingAndErrorProvider>().changeState(LoadingErrorState.DONE);

    }

    return map;
  }
}
