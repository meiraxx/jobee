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
import 'package:jobee/widgets/widget_utils/preload_image.dart' show loadImage;
import 'package:provider/provider.dart' show MultiProvider, StreamProvider;
import 'package:jobee/theme/jobee_theme_data.dart' show JobeeThemeData;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

Future<void> main() async {
  // note: set to true when deploying
  const bool useProductionBackend = true;

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

  // pre-loadings
  await loadImage(const AssetImage('images/dude-call.png'));
  await loadImage(const AssetImage('images/bee-logo-07.png'));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> routes = <String, Widget Function(BuildContext)>{
      '/': (BuildContext context) => Wrapper(),
      '/authenticate': (BuildContext context) => Authenticate(),
      '/home': (BuildContext context) => const Home(),
    };

    // TODO: Code Linting (using the 'link' package)
    // TODO: Code Packaging
    // TODO: Code Testing

    return MultiProvider(
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