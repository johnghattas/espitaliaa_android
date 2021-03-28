import 'package:espitalia/GUI/doctor_controll_panel.dart';
import 'package:espitalia/models/user_model.dart';
import 'package:espitalia/providers/loading_and_response_provider.dart';
import 'package:espitalia/repositers/sign_in_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'alerts_class.dart';
import 'handling_auth_error_mixin.dart';

class LoginServices extends HandlingAuthErrors with Alerts{
  final SignInServices signInServices = SignInServices();

  logIn(BuildContext context, {
    required String? email,
    required String? password,
  }) async {
    String token;

    context
        .read<LoadingAndErrorProvider>()
        .changeState(LoadingErrorState.LOADING);
    try {
      var time = DateTime.now();
      print(email??'fady' + ' cxcazsca '+(password??'fady'));

      token = await signInServices.signIn(
          email: email!, password: password!, isOwner: true);

      print('the time of this sequense is ${DateTime.now().difference(time)}');
    } on Exception catch (e) {
      context.read<LoadingAndErrorProvider>()
        ..changeState(LoadingErrorState.ERROR)
        ..setError(e.toString());
      print(e);
      return;
    }

    if (token.isEmpty) {
      context.read<LoadingAndErrorProvider>()
        ..changeState(LoadingErrorState.ERROR)
        ..setError("un handling token");

      return null;
    }

    print(token.isEmpty);

    context
        .read<LoadingAndErrorProvider>()
        .changeState(LoadingErrorState.DONE);

    _putTokenAndPush(context, token);
  }

  signUp(BuildContext context, {
    required String? email,
    required String? name,
    required String? phone,
    required String? password,
  }) async {
    User user = User(
      email: email,
      phone: phone,
      isDoctor: true,
      name:  name,
    );
    String? token;

    context
        .read<LoadingAndErrorProvider>()
        .changeState(LoadingErrorState.LOADING);

    try {
      token = await signInServices.signUp(
          user: user, password: password!);
    } catch (e) {
      context.read<LoadingAndErrorProvider>()
        ..changeState(LoadingErrorState.ERROR)
        ..setError(e.toString());
      throw e;
    }

    if (token == null || token.isEmpty) {
      context.read<LoadingAndErrorProvider>()
        ..changeState(LoadingErrorState.ERROR)
        ..setError("un handling token");
      return;
    }
    context
        .read<LoadingAndErrorProvider>()
        .changeState(LoadingErrorState.DONE);
    _putTokenAndPush(context, token);
  }

  Future<User?> _addTokenInHive(String token) async {
    Box userBox = Hive.box('user_data');
    userBox.put('token', token);

    print('token is --------' + userBox.get('token'));
    User? user = await signInServices.getUser(token);

    if (user != null) {
      userBox.put('data', user);
      print('user is --------' + userBox.get('data').name);
    }

    print('DONE ENTER THE TOKEN');
    return user;
  }

  void _putTokenAndPush(BuildContext context, String token) async{
    User? user = await _addTokenInHive(token)?..isDoctor = signInServices.userFunction;
    context.read<LoadingAndErrorProvider>().changeState(LoadingErrorState.DONE);

    if (user == null) {
      return;
    }
    if (user.isDoctor!) {
      //to Admin page
      Navigator.pushNamedAndRemoveUntil(
          context, DoctorPanel.NAME, (router) => !router.navigator!.canPop());
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, 'home', (router) => !router.navigator!.canPop());
    }
  }
}
