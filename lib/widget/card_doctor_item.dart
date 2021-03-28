import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
class CardDoctorItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final Doctor? doctor;

  const CardDoctorItem({
    Key? key, this.onPressed, this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: this.onPressed,
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: kPrimaryColor[300],
                    child: Image.asset('assets/espitalia.png'),
                  ),
                  title: Text(
                    doctor?.name??'',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    doctor?.spatial??'',
                    style:
                    TextStyle(color: kPrimaryColor, fontSize: kSmallSize),
                  ),
                  trailing: Icon(CupertinoIcons.heart, color: kBlackColor),
                ),

                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FixedColumnWidth(40),
                  },
                  children: [
                    TableRow(children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Icon(
                          CupertinoIcons.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text('Dentist'),
                    ]),
                    TableRow(children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Icon(
                          CupertinoIcons.location,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text('Address: fdslakjfaksjd fksdajf sfjasd'),
                    ]),
                    TableRow(children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Icon(
                          CupertinoIcons.ellipsis,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text('Detection price'),
                    ]),
                  ],
                ),
                VerticalSpacing(of: 10),
                MaterialButton(
                  elevation: 0.0,
                  onPressed: this.onPressed,
                  height: getProportionateScreenHeight(30),
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('Book now', style: TextStyle(color: kWhiteColor),),
                ),

                VerticalSpacing(of: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
