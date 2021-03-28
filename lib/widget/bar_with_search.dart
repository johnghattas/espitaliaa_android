import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class BarWithSearch extends StatelessWidget {
  final String text;
  final String hintText;
  final bool isHasFilter;
  final VoidCallback? onTapFilter;
  final ValueChanged<String>? onChanged;

  const BarWithSearch({
    Key? key,
    this.text = "",
    this.isHasFilter = false,
    this.onTapFilter,
    this.onChanged,
    this.hintText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: getProportionateScreenHeight(140),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: Text(
            this.text,
            style: kStyle.copyWith(color: kWhiteColor),
          ),
        ),
        Positioned(
          bottom: getProportionateScreenHeight(50),
          left: getProportionateScreenHeight(40),
          right: getProportionateScreenHeight(40),
          child: EditTextWithFilter(
            hintText: this.hintText,
            isHasFilter: this.isHasFilter,
            onTapFilter: this.onTapFilter,
            onChanged: this.onChanged,
          ),
        ),
      ],
    );
  }
}

class EditTextWithFilter extends StatelessWidget {
  final String hintText;
  final bool isHasFilter;
  final VoidCallback? onTapFilter;
  final ValueChanged<String>? onChanged;

  const EditTextWithFilter({
    Key? key,
    this.hintText = '',
    this.isHasFilter = false,
    this.onTapFilter,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.cyan[300], borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(10),
          height: getProportionateScreenHeight(40),
          child: Center(
            child: TextField(
              onChanged: this.onChanged,
              style: TextStyle(
                fontSize: kMediumSize,
                color: kWhiteColor,
              ),
              cursorColor: kBlackColor,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: this.hintText,
                hintStyle: TextStyle(
                  fontSize: kSmallSize,
                  color: kWhiteColor,
                ),
                icon: Icon(
                  Icons.search,
                  color: kWhiteColor,
                  size: 18,
                ),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        (this.isHasFilter)
            ? Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: getProportionateScreenHeight(40),
            height: getProportionateScreenHeight(40),
            decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: Icon(
                CupertinoIcons.slider_horizontal_3,
                color: kBlackColor,
              ),
              onPressed: this.onTapFilter,
              padding: EdgeInsets.zero,
            ),
          ),
        )
            : SizedBox.shrink()
      ],
    );
  }
}
