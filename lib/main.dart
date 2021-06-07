import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DocConnect/screens/doctorProfile.dart';
import 'package:DocConnect/screens/firebaseAuth.dart';
import 'package:DocConnect/mainPage.dart';
import 'package:DocConnect/screens/myAppointments.dart';
import 'package:DocConnect/screens/skip.dart';
import 'package:DocConnect/screens/userProfile.dart';
import 'package:DocConnect/screens/register.dart';
import 'package:DocConnect/screens/signIn.dart';
import 'package:DocConnect/screens/forgot_password_screen.dart';
import 'package:DocConnect/screens/tensorflow.dart';
import 'package:DocConnect/screens/homePage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SignIn(),
        '/login': (context) => FireBaseAuth(),
        '/home': (context) => MainPage(),
        '/profile': (context) => UserProfile(),
        '/MyAppointments': (context) => MyAppointments(),
        '/DoctorProfile': (context) => DoctorProfile(),
        '/Tensorflow': (context) => Tensorflow(),
        '/SignIn': (context) => SignIn(),
        '/homePage': (context) => HomePage(),
        '/mainPage': (context) => MainPage(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
      },
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      //home: FirebaseAuthDemo(),
    );
  }
}
