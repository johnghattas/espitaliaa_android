import 'package:espitalia/GUI/doctor_controll_panel.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/models/user_model.dart';
import 'package:espitalia/shred/custom_button_widget.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size(0, 0),
        child: AppBar(
          backgroundColor: kPrimaryColor,
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacing(
                of: kDefaultPadding * 2,
              ),
              InkWell(
                onTap: () {
                  User? user = Hive.box('user_data').get('data');
                  if (user?.isDoctor ?? false) {
                    Navigator.pushNamed(context, DoctorPanel.NAME);
                  } else
                    Navigator.pushNamed(context, 'home');
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // VerticalSpacing(of: 80,),
              Spacer(
                flex: 3,
              ),
              Center(
                child: Image.asset(
                  'assets/espitalia.png',
                  fit: BoxFit.cover,
                  height: 100,
                  width: 200,
                ),
              ),
              Spacer(
                flex: 2,
              ),
              CustomButton(
                child: Text(
                  'Login',
                  style: TextStyle(color: kPrimaryColor),
                ),
                onPressed: () => Navigator.pushNamed(context, 'login'),
              ),
              VerticalSpacing(of: kDefaultPadding / 1.5),
              MaterialButton(
                minWidth: double.infinity,
                height: getProportionateScreenHeight(50),
                color: kWhiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                onPressed: () => Navigator.pushNamed(context, 'register'),
                child: Text(
                  'Register',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),

              Spacer(
                flex: 3,
              ),

              Center(
                child: Text(
                  'By logging in, you agree to our Terms of Service and Privacy Policy',
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(11),
                      color: kWhiteColor),
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
