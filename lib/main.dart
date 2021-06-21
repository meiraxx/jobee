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

    ThemeData lightThemeData = ThemeData(
      colorScheme: ColorScheme(
        primary: const Color(0xFFF7B61C), /* lightPaletteColors['crispYellow']! */
        primaryVariant: const Color(0xFFFFAE2A), /* lightPaletteColors['orange']! */
        secondary: const Color(0xFFFFFAD8), /* lightPaletteColors['cream']! */
        secondaryVariant: const Color(0xFFFDD329), /* lightPaletteColors['yellow']! */
        surface: Colors.white,
        background: Colors.white,
        error: const Color(0xFFB00020),
        onPrimary: const Color(0xFFF6F6F4), /* lightPaletteColors['lightGray']! */
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: const Color(0xFFF6F6F4), /* lightPaletteColors['lightGray']! */
        brightness: Brightness.light
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightPaletteColors["cream"]!,
      ),
      scaffoldBackgroundColor: lightPaletteColors["cream"]!,
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 1,
        labelStyle: TextStyle(
          color: const Color(0xFF616161), // Colors.grey[700]
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFF7B61C),
            width: 2.0
          )
        ),
      )
    );

    ThemeData darkThemeData = ThemeData(
      colorScheme: ColorScheme(
        primary: const Color(0xFFBB86FC),
        primaryVariant: const Color(0xFF3700B3),
        secondary: const Color(0xFF03DAC6),
        secondaryVariant: const Color(0xFF03DAC6),
        surface: const Color(0xFF121212),
        background: const Color(0xFF121212),
        error: const Color(0xFFcf6679),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
        brightness: Brightness.dark
      )
    );

    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService.user,
      child: MaterialApp(
        /* light theme settings */
        theme: JobeeThemeData.lightThemeData,
        /* dark theme settings */
        darkTheme: darkThemeData,
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