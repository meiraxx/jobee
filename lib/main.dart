import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/authenticate/authenticate.dart';
import 'package:jobee/screens/home/home.dart';
import 'package:jobee/screens/wrapper.dart';
import 'package:jobee/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:jobee/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:jobee/theme/jobee_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initializeFirebaseApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(BuildContext)> routes = {
      '/': (BuildContext context) => Wrapper(),
      '/authenticate': (BuildContext context) => Authenticate(),
      '/home': (BuildContext context) => Home(),
    };

    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService.user,
      child: MaterialApp(
        /* light theme settings */
        theme: JobeeThemeData.lightThemeData,
        /* dark theme settings */
        darkTheme: JobeeThemeData.darkThemeData,
        /*
          ThemeMode:
          - ThemeMode.system to follow system theme
          - ThemeMode.light for light theme
          - ThemeMode.dark for dark theme
        */
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute(builder: (BuildContext context) => routes[settings.name]!(context), fullscreenDialog: false);
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          Locale('pt', 'PT'),
          Locale('en', 'UK'),
          Locale('en', 'US'),
        ],
      ),
    );
  }
}