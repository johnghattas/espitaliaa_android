import 'package:espitalia/constant.dart';
import 'package:espitalia/providers/loading_and_response_provider.dart';
import 'package:espitalia/repositers/sign_in_app.dart';
import 'package:espitalia/shred/custom_button_widget.dart';
import 'package:espitalia/shred/custom_text_field.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:espitalia/shred/sign_in_project_servies.dart';
import 'package:espitalia/shred/validate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum Method { user , doctor }

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with Validate {
  late SignInServices _signInServices;
  final _formKey = GlobalKey<FormState>();
  final LoginServices loginServices = LoginServices();

  String? _email;
  String? _password;
  String? _phone;
  String? _name;

  @override
  Widget build(BuildContext context) {
    loginServices.handleException(context);

    SizeConfig().init(context);
print('reload the builder');

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Register',
                      style: TextStyle(color: kBlackColor, fontSize: 20),
                    ),
                    subtitle: Text(
                      'Register a new account and book now',
                      style: TextStyle(fontSize: kSmallSize),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  VerticalSpacing(of: 50),
                  CustomTextField(
                    icon: Icons.person,
                    hint: 'Name',
                    onSaved: (value) => _name = value,
                    validate: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter Name';
                      }
                    },
                  ),
                  VerticalSpacing(of: kDefaultPadding * 0.5),
                  CustomTextField(
                    icon: Icons.phone,
                    hint: 'phone',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _phone = value,
                    validate: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter Phone';
                      } else if (value != null && value.length != 11) {
                        return 'should be 11 digit';
                      }
                    },
                  ),
                  VerticalSpacing(of: kDefaultPadding * 0.5),
                  CustomTextField(
                    icon: Icons.email,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value,
                    validate: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter Email';
                      } else if (value != null && !isEmail(value)) {
                        return 'Enter correct email';
                      }
                    },
                  ),
                  VerticalSpacing(of: kDefaultPadding * 0.5),
                  ListenableProvider.value(
                    value: context.read<LoadingAndErrorProvider>(),

                    builder: (context, child) {
                      var isDoctor = context.read<LoadingAndErrorProvider>().isDoctor?Method.doctor:Method.user;

                      return Row(
                      children: [
                        Text('Function', style: kStyle),
                        HorizontalSpace(of: kDefaultPadding * 2),
                        Text('User',
                            style: kStyle.copyWith(
                                color: kBlackColor,
                                fontWeight: FontWeight.normal)),
                        Radio(
                          value: Method.user,
                          groupValue: isDoctor,
                          onChanged: (value) {
                            bool method = _doctorMethod(value as Method);
                            _signInServices.user = method;
                            context.read<LoadingAndErrorProvider>().changeCheck(method);

                          },
                        ),
                        HorizontalSpace(of: kDefaultPadding * 2),
                        Text('Doctor',
                            style: kStyle.copyWith(
                                color: kBlackColor,
                                fontWeight: FontWeight.normal)),
                        Radio(
                          value: Method.doctor,
                          groupValue: isDoctor,
                          onChanged: ( value) {
                            bool method = _doctorMethod(value as Method);
                            _signInServices.user = method;
                            context.read<LoadingAndErrorProvider>().changeCheck(method);

                          },
                        ),
                      ],
                    );
                    },
                  ),
                  VerticalSpacing(of: kDefaultPadding * 0.5),
                  CustomTextField(
                    icon: Icons.calendar_today_sharp,
                    hint: 'Age',
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                  ),
                  VerticalSpacing(of: kDefaultPadding * 0.5),
                  CustomTextField(
                    icon: Icons.lock,
                    hint: 'Password',
                    isSecure: true,
                    onSaved: (value) => _password = value,
                    validate: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter Password';
                      } else if (value != null && value.length < 6) {
                        return 'Password should be greater than 6';
                      }
                    },
                  ),
                  VerticalSpacing(of: kDefaultPadding * 0.5),
                  CustomTextField(
                    icon: Icons.lock,
                    hint: 'Confirm Password',
                    isSecure: true,
                    validate: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter Confirm Password';
                      } else if (value != null && value != _password) {
                        return 'Error Confirm password';
                      }
                    },
                  ),
                  VerticalSpacing(of: kDefaultPadding),
                  VerticalSpacing(of: kDefaultPadding),
                  CustomButton(
                    onPressed: () {
                      _formKey.currentState!.save();

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      loginServices.signUp(context,
                          email: _email,
                          name: _name,
                          phone: _phone,
                          password: _password);
                    },
                    color: kPrimaryColor,
                    child: Text(
                      'Register',
                      style:
                          TextStyle(color: kWhiteColor, fontSize: kMediumSize),
                    ),
                  ),
                  VerticalSpacing(of: kDefaultPadding),
                  _divider(),
                  VerticalSpacing(of: kDefaultPadding),
                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(context, 'login'),
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Have account?  ',
                              style: kStyle.copyWith(
                                  color: kBlackColor,
                                  fontSize: getProportionateScreenHeight(14))),
                          TextSpan(
                            text: 'Login now',
                            style: kStyle.copyWith(
                                fontSize: getProportionateScreenHeight(14)),
                          )
                        ]),
                      ),
                    ),
                  ),
                  VerticalSpacing(of: kDefaultPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signInServices = SignInServices();
  }

   Row _divider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 80,
          height: 2.5,
          child: const Divider(
            color: kGreyColor,
            thickness: 2.5,
          ),
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text('OR'),
        ),
        const SizedBox(
          width: 80,
          height: 2.5,
          child: const Divider(
            color: kGreyColor,
            thickness: 2.5,
          ),
        ),
      ],
    );
  }

  bool _doctorMethod(Method method) => method == Method.doctor?true : false;
}
