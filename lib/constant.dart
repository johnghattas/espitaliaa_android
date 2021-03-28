import 'package:flutter/material.dart';

const kPrimaryColor = Colors.cyan;
const kWhiteColor = Colors.white;
const kGreyColor = Colors.grey;
const kBlackColor = Colors.black;
const kLightCyanColor = Color(0xffbcffef);

const kStyle = TextStyle(color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 16);

const kStyleM = TextStyle(color: kPrimaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 14);

const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double kDefaultPadding = 20.0;
const double kBigSize = 20.0;
const double kMediumSize = 18.0;
const double kSmallSize = 14.0;
