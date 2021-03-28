import 'package:espitalia/constant.dart';
import 'package:flutter/material.dart';

class SocialMediaIcons extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? width;
  final double? height;

  const SocialMediaIcons({
    Key? key,
    @required this.icon,
    @required this.onPressed,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 40,
      height: height ?? 40,
      child: CircleAvatar(
        backgroundColor: this.color ?? kPrimaryColor,
        child: icon,
      ),
    );
  }
}