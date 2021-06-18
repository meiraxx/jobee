import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/authenticate/authenticate.dart';
import 'package:jobee/screens/home/home.dart';
import 'package:jobee/screens/profile/profile.dart';
import 'package:jobee/screens/wrapper.dart';
import 'package:jobee/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initializeFirebaseApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/': (BuildContext context) => Wrapper(),
      '/authenticate': (BuildContext context) => Authenticate(),
      '/home': (BuildContext context) => Home(),
    };

    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService.user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute(builder: (BuildContext context) => routes[settings.name]!(context), fullscreenDialog: false);
        }
      ),
    );
  }
}
