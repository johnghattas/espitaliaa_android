import 'package:espitalia/GUI/doctor_add_information.dart';
import 'package:espitalia/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constant.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomDrawer({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class ListTileDrawer extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final IconData? icon;

  const ListTileDrawer({Key? key, this.onPressed, this.text, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: kPrimaryColor, size: kMediumSize),
      title: Text(
        text ?? '',
        style: kStyle.copyWith(fontSize: kSmallSize, color: kBlackColor),
      ),
      trailing: IconButton(
        icon: Icon(Icons.arrow_right_rounded, color: kPrimaryColor, size: kMediumSize),
        onPressed: onPressed,
      ),
    );
  }
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.5),
        child: ValueListenableBuilder(
          valueListenable: Hive.box('user_data').listenable(),
          builder: (context, Box value, child) {
            User? user = value.get('data');

            print(user?.isDoctor);

            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Hi\n',
                        style: TextStyle(
                            fontSize: 14, color: kBlackColor, height: 1.5),
                      ),
                      TextSpan(
                        text: user?.name ?? '',
                        style: TextStyle(
                            fontSize: kMediumSize,
                            fontWeight: FontWeight.bold,
                            color: kBlackColor,
                            height: 1.5),
                      ),
                    ]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () =>
                        widget.scaffoldKey?.currentState?.openEndDrawer(),
                  ),
                ),
                Divider(
                  thickness: 4,
                  endIndent: 40,
                ),
                (user?.isDoctor ?? false)
                    ? ListTileDrawer(
                        icon: Icons.baby_changing_station,
                        text: 'Add Or Change appointments',
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, DoctorAddInformation.NAME);
                        },
                      )
                    : SizedBox.shrink(),
                ListTileDrawer(
                  icon: Icons.language,
                  text: 'change the language',
                ),
                ListTileDrawer(
                  icon: Icons.phone,
                  text: 'Contact us',
                ),
                ListTileDrawer(
                  icon: CupertinoIcons.question,
                  text: 'About espitaliaa',
                ),
                ListTileDrawer(
                  icon: Icons.share,
                  text: 'Share app',
                ),
                ((value.get('token') ?? '').isNotEmpty)
                    ? ListTileDrawer(
                        icon: Icons.logout,
                        text: 'Logout',
                        onPressed: () {
                          Navigator.pop(context);

                          Navigator.pushNamed(context, 'login');
                        },
                      )
                    : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
