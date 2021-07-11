// template taken from: https://raw.githubusercontent.com/flutter/gallery/master/lib/themes/gallery_theme_data.dart
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/widgets/ink_splash/custom_elevatedButton_ink_splash.dart';
import 'package:jobee/widgets/ink_splash/custom_iconButton_ink_splash.dart';
import 'package:jobee/widgets/ink_splash/custom_textButton_ink_splash.dart';

class JobeeThemeData {

  /// TEXT THEME
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
    headline4: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
    caption: GoogleFonts.roboto(fontWeight: _regular, fontSize: 12.0),
    headline5: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 18.0),
    subtitle1: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 18.0),
    overline: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
    bodyText1: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
    subtitle2: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
    bodyText2: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 13.0),
    headline6: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 18.0),
    button: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
  );

  /// LIGHT COLOR SCHEME
  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: const Color(0xFFFFAE2A), // lightPaletteColors['orange']!
    primaryVariant: const Color(0xFFFF872A), // lightPaletteColors['deeperOrange']!
    secondary: const Color(0xFF2A7BFF), // lightPaletteColors['blue']!
    secondaryVariant: const Color(0xFF442AFF), // lightPaletteColors['darkerBlue']!
    surface: _darkFillColor,
    background: _darkFillColor,
    error: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: _lightFillColor,
    onSurface: _lightFillColor,
    onBackground: _lightFillColor,
    onError: _lightFillColor,
    brightness: Brightness.light,
  );

  /// DARK COLOR SCHEME
  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );


  /// Different Types of Colors

  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static final Color _lightSplashColor = Colors.black12;
  static final Color _darkSplashColor = Colors.white24;

  static final Color _lightHighlightColor = Colors.black12;
  static final Color _darkHighlightColor = Colors.white24;

  static Color get lightSplashColor => _lightSplashColor;
  static Color get darkSplashColor => _darkSplashColor;
  static Color get lightHighlightColor => _lightHighlightColor;
  static Color get darkHighlightColor => _darkHighlightColor;

  /// Light Color Palette
  static const Map<String, Color> _lightPaletteColors = {
    // Palette Colors [Bee]
    "cream": const Color(0xFFFFFAD8),
    "orange": const Color(0xFFFFAE2A),
    "deeperOrange": const Color(0xFFFF872A),
    "yellow": const Color(0xFFFDD329),
    "crispYellow": const Color(0xFFF7B61C),
    "lightGray": const Color(0xFFF6F6F4),
    // Complementary Colors [of the chosen primary, Orange]
    "blue": const Color(0xFF2A7BFF),
    "darkerBlue": const Color(0xFF442AFF),
    // More Colors
    "error": const Color(0xFFB00020), /* used for errors */
    "white": Colors.white, /* white */
    "black": Colors.black, /* black */
  };
  static Map<String, Color> get lightPaletteColors => _lightPaletteColors;

  static ThemeData lightThemeData = themeData(_lightColorScheme, _textTheme, _lightFocusColor, _lightFillColor, _darkFillColor, _lightSplashColor, _lightHighlightColor);
  static ThemeData darkThemeData = themeData(_darkColorScheme, _textTheme, _darkFocusColor, _lightFillColor, _darkFillColor, _darkSplashColor, _darkHighlightColor);

  static ThemeData themeData(ColorScheme colorScheme, TextTheme textTheme, Color defaultFocusColor, Color lightFillColor, Color darkFillColor,
      Color defaultSplashColor, Color defaultHighlightColor) {
    return ThemeData(
      colorScheme: colorScheme,
      // apply colorScheme colors to the default-colored textTheme
      textTheme: textTheme.copyWith(
        headline4: textTheme.headline4!.copyWith(color: colorScheme.onPrimary),
        caption: textTheme.caption!.copyWith(color: colorScheme.onPrimary),
        headline5: textTheme.headline5!.copyWith(color: colorScheme.onPrimary),
        subtitle1: textTheme.subtitle1!.copyWith(color: colorScheme.onPrimary),
        overline: textTheme.overline!.copyWith(color: colorScheme.onPrimary),
        bodyText1: textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary),
        subtitle2: textTheme.subtitle2!.copyWith(color: colorScheme.onPrimary),
        bodyText2: textTheme.bodyText2!.copyWith(color: colorScheme.onPrimary),
        headline6: textTheme.headline6!.copyWith(color: colorScheme.onPrimary),
        button: textTheme.button!.copyWith(color: colorScheme.onPrimary),
      ),
      // TODO: validate if primaryTextTheme or accentTextTheme are needed.
      // Matches manifest.json colors and background color.
      primaryColor: colorScheme.primary, // this is not the "primary color", but the color used above the primary
      accentColor: colorScheme.secondary, // this is the color used for accents, i.e., the secondary color
      backgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        textTheme: textTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.primary,
        elevation: 0.0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
        brightness: colorScheme.brightness,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 5.0,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary,
        selectionHandleColor: colorScheme.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          lightFillColor.withOpacity(0.80),
          darkFillColor,
        ),
        contentTextStyle: textTheme.subtitle1!.apply(color: darkFillColor),
      ),
      // TODO: make splash/highlight effects faster
      // TODO:get more neutral colors for splash/highlight effects (white-ish or black-ish)
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
        colorScheme: colorScheme,
        splashColor: defaultSplashColor,
        highlightColor: defaultHighlightColor,
      ),
      splashFactory: CustomIconButtonInkSplash.splashFactory,  // custom iconButton splash factory
      splashColor: defaultSplashColor,
      highlightColor: defaultHighlightColor,
      focusColor: defaultFocusColor,
      // note: default disabled color is always Colors.grey
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 3,
        contentPadding: EdgeInsets.all(5.0),
        alignLabelWithHint: true,
        border: UnderlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        ).copyWith(
          overlayColor: MaterialStateProperty.all( lightPaletteColors["yellow"]!.withAlpha(0x7F) ),
          splashFactory: CustomElevatedButtonInkSplash.splashFactory,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all( Colors.black12 ),
          splashFactory: CustomTextButtonInkSplash.splashFactory, // custom textButton splash factory
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        margin: EdgeInsets.zero,
      ),
      // TODO: understand why pageTransitionsTheme is not working
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  // originals, taken from flutter gallery
  static const ColorScheme originalLightColorScheme = ColorScheme(
    primary: Color(0xFFB93C5D),
    primaryVariant: Color(0xFF117378),
    secondary: Color(0xFFEFF3F3),
    secondaryVariant: Color(0xFFFAFBFB),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  // taken from flutter gallery
  static const ColorScheme originalDarkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );
}