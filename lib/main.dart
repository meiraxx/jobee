import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:firebase_core/firebase_core.dart' show Firebase;
//import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
//import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
//import 'package:cloud_functions/cloud_functions.dart' show FirebaseFunctions;
//import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:jobee/models/app_user.dart' show AppUser;
import 'package:jobee/screens/package1_authenticate/1.0_authenticate.dart' show Authenticate;
import 'package:jobee/screens/package4_home/4.0_home.dart' show Home;
import 'package:jobee/screens/package0_wrapper/0.0_auth_wrapper.dart' show AuthWrapper;
import 'package:jobee/services/auth.dart' show AuthService;
import 'package:jobee/widgets/widget_utils/preload_image.dart' show loadImage;
import 'package:provider/provider.dart' show MultiProvider, StreamProvider;
import 'package:jobee/theme/jobee_theme_data.dart' show JobeeThemeData;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // - Initialize firebase app
  await Firebase.initializeApp();

  // use emulators rather than real firebase for testing purposes,
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  //await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  // - Pre-load essential images
  // Asset images
  await loadImage(const AssetImage('images/dude-call.png'));
  await loadImage(const AssetImage('images/bee-logo-07.png'));
  await loadImage(const AssetImage('images/google-logo-1080x1080.png'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> routes = <String, Widget Function(BuildContext)>{
      '/': (BuildContext context) => const AuthWrapper(),
      '/authenticate': (BuildContext context) => const Authenticate(),
      '/home': (BuildContext context) => const Home(),
    };

    // DONE: Code Linting (using the 'link' package)
    // TODO: Code Packaging
    // TODO: Code Testing

    // Non-authenticated MultiProvider
    return MultiProvider(
      // Non-Authenticated providers
      providers: <SingleChildWidget>[
        StreamProvider<AppUser?>.value(initialData: null, value: AuthService.user),
      ],
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
          return CupertinoPageRoute<dynamic>(builder: (BuildContext context) => routes[settings.name]!(context));
        },
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('pt', 'PT'),
          Locale('en', 'UK'),
          Locale('en', 'US'),
        ],
      ),
    );
  }
}