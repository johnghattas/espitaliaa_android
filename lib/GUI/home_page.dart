import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/shred/custom_drawer.dart';
import 'package:espitalia/shred/screen_sized.dart';
import 'package:espitalia/widget/function_element_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.8),
          child: Column(
            children: [
              VerticalSpacing(of: 70),
              Image.asset(
                'assets/espitalia.png',
                fit: BoxFit.cover,
                height: 50,
                width: 150,
              ),
              VerticalSpacing(of: 80),
              FunctionElementWidget(
                text: 'Search for a doctor',
                icon: Icons.person,
                onPressed: () => Navigator.pushNamed(context, 'doctors'),
              ),
              VerticalSpacing(of: kDefaultPadding * 0.5),
              FunctionElementWidget(
                text: 'Hospital or center',
                icon: Icons.local_hospital_outlined,
                onPressed: () {},
              ),
              VerticalSpacing(of: kDefaultPadding * 0.5),
              FunctionElementWidget(
                text: 'Laboratories analysis',
                icon: Icons.label,
                onPressed: () {},
              ),
              VerticalSpacing(of: kDefaultPadding * 0.5),
              FunctionElementWidget(
                text: 'X-ray centers',
                icon: Icons.clean_hands,
                onPressed: () {},
              ),
              VerticalSpacing(of: 100),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: CustomDrawer(scaffoldKey: scaffoldKey),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: kPrimaryColor,
        items: <Widget>[
          Icon(Icons.search, size: 25, color: kPrimaryColor),
          Icon(Icons.animation, size: 25, color: kPrimaryColor),
          Icon(Icons.calendar_today_sharp, size: 25, color: kPrimaryColor),
          Icon(Icons.notifications_none, size: 25, color: kPrimaryColor),
          Icon(CupertinoIcons.ellipsis, size: 25, color: kPrimaryColor),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }
}
