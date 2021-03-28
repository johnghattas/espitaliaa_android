import 'package:espitalia/GUI/choose_your_time_page.dart';
import 'package:espitalia/GUI/doctor_add_information.dart';
import 'package:espitalia/GUI/doctor_controll_panel.dart';
import 'package:espitalia/GUI/doctor_page.dart';
import 'package:espitalia/GUI/doctors_page.dart';
import 'package:espitalia/GUI/home_page.dart';
import 'package:espitalia/GUI/login_page.dart';
import 'package:espitalia/GUI/register_page.dart';
import 'package:espitalia/GUI/sign_page.dart';
import 'package:espitalia/bloc/admin_bloc.dart';
import 'package:espitalia/bloc/appointments_bloc.dart';
import 'package:espitalia/constant.dart';
import 'package:espitalia/models/Doctor.dart';
import 'package:espitalia/models/user_model.dart';
import 'package:espitalia/providers/loading_and_response_provider.dart';
import 'package:espitalia/repositers/admin_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'repositers/doctor_info_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent));

  runApp(MyApp());

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('user_data');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoadingAndErrorProvider>(
            create: (context) => LoadingAndErrorProvider()),
        BlocProvider<AppointmentsBloc>(
          create: (context) =>
              AppointmentsBloc(doctorInfoRepo: DoctorInfoRepo()),
        ),
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(adminRepo: AdminRepo()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: kWhiteColor),
            iconTheme: IconThemeData(color: kWhiteColor),
            brightness: Brightness.dark,
          ),
          // primarySwatch: kPrimaryColor,
          accentColor: kPrimaryColor,
          primaryColor: kPrimaryColor,
          primaryIconTheme: IconThemeData(color: kPrimaryColor),
        ),
        darkTheme: ThemeData.light(),
        routes: {
          'login': (context) => LoginPage(),
          'register': (context) => RegisterPage(),
          'home': (context) => HomePage(),
          'doctors': (context) => DoctorsPage(),
          'doctor': (context) {
            final parameter = ModalRoute.of(context)?.settings.arguments
                as Map<String, String>;
            return DoctorPage(
              email: parameter['email'] ?? "",
            );
          },
          'chooseTime': (context) {
            final parameter = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>;
            return ChooseTime(
              listAppoints:
                  (parameter['appointments'] as List).cast<Appointment>(),
              index: parameter['index'] as int,
              doctor: (parameter['doctor']),
            );
          },
          'setAppointment': (_) => DoctorAddInformation(),
          DoctorPanel.NAME: (_) => DoctorPanel(),
          DoctorAddInformation.NAME: (_) => DoctorAddInformation(),
        },
        home: SignPage(),
      ),
    );
  }
}
