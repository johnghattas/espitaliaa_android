import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class FunctionElementWidget extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final VoidCallback? onPressed;
  const FunctionElementWidget({
    Key? key, this.icon, this.text, @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: kWhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
            ),
            HorizontalSpace(of: 20),
            Expanded(
                child: Text(
                  text ?? '',
                  style: kStyle.copyWith(fontWeight: FontWeight.normal),
                )),
            IconButton(
              icon: Icon(Icons.arrow_forward, color: kPrimaryColor ,),
              onPressed: onPressed,
              padding: EdgeInsets.zero,
            )
          ],
        ),
      ),
    );
  }
}
