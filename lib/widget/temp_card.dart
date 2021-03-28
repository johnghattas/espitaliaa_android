import 'package:flutter/material.dart';

import '../constant.dart';

class TemplateCard extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String subText;

  const TemplateCard({
    Key? key,
    this.icon,
    this.text = '',
    this.subText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                offset: Offset(0.0, 0.6),
                color: kBlackColor.withOpacity(0.2))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(this.icon, size: 14, color: kPrimaryColor),
                SizedBox(width: 10),
                Text(this.text,
                    style: TextStyle(fontSize: kSmallSize, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(height: 8),
            Text(
              this.subText,
              style: TextStyle(fontSize: 12, color: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
