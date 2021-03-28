import 'package:espitalia/constant.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Widget? child;
  final VoidCallback? onPressed;
  const CustomButton({
    Key? key,
    this.color = kWhiteColor,
    this.child,
    @required this.onPressed
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: onPressed,
      minWidth: double.infinity,
      height: getProportionateScreenHeight(50),
      color: this.color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: this.child,
    );
  }
}