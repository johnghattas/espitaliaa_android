import 'package:espitalia/constant.dart';
import 'package:espitalia/providers/loading_and_response_provider.dart';
import 'package:espitalia/repositers/sign_in_app.dart';
import 'package:espitalia/shred/custom_button_widget.dart';
import 'package:espitalia/shred/custom_text_field.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:espitalia/shred/sign_in_project_servies.dart';
import 'package:espitalia/shred/validate.dart';
import 'package:espitalia/widget/social_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validate {
  late SignInServices _signInServices;
  final _formKey = GlobalKey<FormState>();
  final LoginServices loginServices = LoginServices();

  String? _email;
  String? _password;


  @override
  Widget build(BuildContext context) {
    loginServices.handleException(context);
    print('john');

    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Login',
                    style: TextStyle(color: kBlackColor, fontSize: 20),
                  ),
                  subtitle: Text(
                    'Login to continue booking',
                    style: TextStyle(fontSize: kSmallSize),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                VerticalSpacing(of: 100),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      VerticalSpacing(of: kDefaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Is Doctor'),
                          HorizontalSpace(of: kDefaultPadding),
                          Consumer<LoadingAndErrorProvider>(
                            builder: (context, value, child) => Checkbox(
                                value: value.isDoctor,
                                onChanged: (v) {
                                  print('this value' + v.toString());

                                  _signInServices.user = v ?? false;
                                  value.changeCheck(v ?? false);
                                }),
                          )
                        ],
                      ),
                      VerticalSpacing(of: kDefaultPadding),
                      CustomButton(
                        onPressed: () {
                          // Form.of(primaryFocus!.context!)!.save();
                          _formKey.currentState!.save();

                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          print('this is password $_password');

                          loginServices.logIn(context,
                              password: _password, email: _email);
                        },
                        color: kPrimaryColor,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: kWhiteColor, fontSize: kMediumSize),
                        ),
                      ),
                      VerticalSpacing(of: kDefaultPadding),
                      Text('Forgot Password?',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: kSmallSize,
                              fontWeight: FontWeight.bold)),
                      VerticalSpacing(of: kDefaultPadding),
                      _divider(),
                      VerticalSpacing(of: kDefaultPadding * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialMediaIcons(
                            icon: Text(
                              'G',
                              style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: SocialMediaIcons(
                              icon: Text(
                                'f',
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.indigo,
                              onPressed: () {},
                            ),
                          ),
                          SocialMediaIcons(
                            icon: Icon(CupertinoIcons.ellipsis_circle_fill,
                                color: kWhiteColor),
                            color: Colors.grey[500],
                            onPressed: () {},
                          ),
                        ],
                      ),
                      VerticalSpacing(of: kDefaultPadding * 2.5),
                      Center(
                        child: InkWell(
                          onTap: () => Navigator.pushReplacementNamed(context, 'register'),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Have no account?  ',
                                  style: kStyle.copyWith(
                                      color: kBlackColor,
                                      fontSize:
                                          getProportionateScreenHeight(14))),
                              TextSpan(
                                text: 'Register now',
                                style: kStyle.copyWith(
                                    fontSize: getProportionateScreenHeight(14)),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalSpacing(of: 100),
              ],
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
}
