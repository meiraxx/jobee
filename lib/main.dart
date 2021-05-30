import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/authenticate/auth_mail_password.dart';
import 'package:jobee/screens/authenticate/authenticate.dart';
import 'package:jobee/screens/authenticate/reg_mail_password.dart';
import 'package:jobee/screens/home/home.dart';
import 'package:jobee/screens/wrapper.dart';
import 'package:jobee/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/authenticate': (context) => Authenticate(),
          '/home': (context) => Home(),
        }
      ),
    );
  }
}
