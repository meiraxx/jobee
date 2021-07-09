// template taken from: https://raw.githubusercontent.com/flutter/gallery/master/lib/themes/gallery_theme_data.dart
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobeeThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(_lightColorScheme, _textTheme, _lightFocusColor, _lightFillColor, _darkFillColor);
  static ThemeData darkThemeData = themeData(_darkColorScheme, _textTheme, _darkFocusColor, _lightFillColor, _darkFillColor);

  static ThemeData themeData(ColorScheme colorScheme, TextTheme textTheme, Color focusColor, Color lightFillColor, Color darkFillColor) {
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
        color: colorScheme.background,
        elevation: 0.5,
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
        splashColor: colorScheme.secondary.withAlpha(0x7F),
        highlightColor: colorScheme.secondary.withAlpha(0x7F),
      ),
      splashColor: colorScheme.secondary.withAlpha(0x7F),
      highlightColor: colorScheme.secondary.withAlpha(0x7F),
      focusColor: focusColor,
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
          overlayColor: MaterialStateProperty.all(colorScheme.secondary.withAlpha(0x7F)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle( overlayColor: MaterialStateProperty.all(Colors.transparent) ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        margin: EdgeInsets.zero,
      ),
    );
  }

  static const ColorScheme _lightColorScheme = ColorScheme(
    /*
    // ORIGINAL PRIMARY COLORS, BASED ON THE FACT THAT AN EXAMPLE I FOUND OF A LIGHT THEME
    // USED DARKER SECONDARY COLORS
    primary: const Color(0xFFFDD329), // lightPaletteColors['yellow']!
    primaryVariant: const Color(0xFFF7B61C), // lightPaletteColors['crispYellow']!
    secondary: const Color(0xFFFFAE2A), // lightPaletteColors['orange']!
    secondaryVariant: const Color(0xFFFF872A), // lightPaletteColors['deeperOrange']!
    */
    // NEW TESTING PRIMARY COLORS, BASED ON THE FACT THAT A PRIMARY YELLOW ON CREAM IS NOT
    // VERY FRIENDLY, SO WE'LL ONLY USE YELLOWS WHEN WE NEED TO ACCENT SOMETHING DARKER
    // (from what I've tested until now, this looks a lot better than the other version)
    primary: const Color(0xFFFFAE2A), // lightPaletteColors['orange']!
    primaryVariant: const Color(0xFFFF872A), // lightPaletteColors['deeperOrange']!
    secondary: const Color(0xFFFDD329), // lightPaletteColors['yellow']!
    secondaryVariant: const Color(0xFFF7B61C), // lightPaletteColors['crispYellow']!
    surface: _darkFillColor, // lightPaletteColors['cream']! = const Color(0xFFFFFAD8)
    background: _darkFillColor, // lightPaletteColors['cream']! = const Color(0xFFFFFAD8)
    error: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: _lightFillColor,
    onSurface: _lightFillColor,
    onBackground: _lightFillColor,
    onError: _lightFillColor,
    brightness: Brightness.light,
  );

  // taken from flutter gallery
  static const ColorScheme lightColorScheme = ColorScheme(
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

  // taken from flutter gallery
  static const ColorScheme darkColorScheme = ColorScheme(
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
}