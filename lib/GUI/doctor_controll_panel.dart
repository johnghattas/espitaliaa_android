import 'package:espitalia/shred/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class DoctorPanel extends StatelessWidget {
  static const NAME = 'doctor_panel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawer(child: CustomDrawer()),
    );
  }
}
