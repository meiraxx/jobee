import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:cloud_functions/cloud_functions.dart' show FirebaseFunctions;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:jobee/models/app_user.dart' show AppUser;
import 'package:jobee/screens/authenticate/authenticate.dart' show Authenticate;
import 'package:jobee/screens/home/home.dart' show Home;
import 'package:jobee/screens/wrapper.dart' show Wrapper;
import 'package:jobee/services/auth.dart' show AuthService;
import 'package:provider/provider.dart' show MultiProvider, StreamProvider;
import 'package:jobee/theme/jobee_theme_data.dart' show JobeeThemeData;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

void main() async {
  // note: set to true when deploying
  bool useProductionBackend = true;

  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app
  await Firebase.initializeApp();

  // use emulators rather than real firebase for testing purposes,
  if (!useProductionBackend) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }

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

    return MultiProvider(
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
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('pt', 'PT'),
          Locale('en', 'UK'),
          Locale('en', 'US'),
        ],
      ),
      providers: <SingleChildWidget>[
        StreamProvider<AppUser?>.value(initialData: null, value: AuthService.user),
      ],
    );
  }
}