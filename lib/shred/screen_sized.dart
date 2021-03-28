
import 'package:flutter/material.dart';

double getHeightWhenOrientationLand(double inputHeight, [double min = 0]) {
  double screenWidth = SizeConfig.height ?? 0.0;
  double value = (inputHeight / 392.72727272727275) * screenWidth;
  return value < min ? inputHeight : value;
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.height??0;
  // Our designer use iPhone 11 , that's why we use 896.0
  return (inputHeight / 759.2727272727273) * screenHeight;
}
// Get the proportionate height as per screen size when orientation [portrait]
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.width ?? 0.0;
  // 414 is the layout width that designer use or you can say iPhone 11  width
  return (inputWidth / 392.72727272727275) * screenWidth;
}

// Get the proportionate height as per screen size
class HorizontalSpace extends StatelessWidget {
  final double of;

  const HorizontalSpace({
    Key? key,
    this.of = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(of),
    );
  }
}

// For add free space vertically
class SizeConfig {
  static double? height;
  static double? width;
  static Orientation? orientation;
  static double? bottom;
  static bool get isKeyBoardOpen => (bottom??0.0) > 0.0;



  MediaQueryData? _mediaQuery ;



  void init(BuildContext context) {

    _mediaQuery = MediaQuery?.of(context);
    height = _mediaQuery!.size.height;
    width = _mediaQuery!.size.width;
    orientation = _mediaQuery!.orientation;
    bottom = _mediaQuery!.viewInsets.bottom;
  }

  // static double get screenHeight => orientation == Orientation.portrait ? height - bottom : height;
}// For add free space vertically
class VerticalSpacing extends StatelessWidget {
  final double of;

  const VerticalSpacing({
    Key? key,
    this.of = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(of),
    );
  }
}