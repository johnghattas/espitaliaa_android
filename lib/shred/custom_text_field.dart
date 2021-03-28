
import 'package:flutter/material.dart';

import '../constant.dart';

typedef ValidateFunction = String? Function(String? value);
class CustomTextField extends StatelessWidget {
  final String? hint;
  final IconData? icon;
  final bool? isSecure;
  final TextInputType? keyboardType;
  final ValidateFunction? onSaved;
  final ValidateFunction? validate;

  const CustomTextField({
    Key? key,
    this.hint,
    @required this.icon,
     this.onSaved,
    this.isSecure = false, this.keyboardType, this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20 / 1.5),
      color: kLightCyanColor,
      child: TextFormField(
        onSaved: onSaved,
        validator: validate,
        obscureText: isSecure!,
        style: TextStyle(fontSize: kSmallSize),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: false,
          errorMaxLines: 1,
          focusColor: kPrimaryColor,
          hintText: hint ?? "",
          icon: SizedBox(
            width: 40,
            child: Row(
              children: [
                Spacer(),
                Icon(
                  this.icon,
                  color: kPrimaryColor,
                  size: 18,
                ),
                Spacer(),
                Container(
                  width: 1,
                  height: 18,
                  color: kPrimaryColor,
                )
              ],
            ),
          ),
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
