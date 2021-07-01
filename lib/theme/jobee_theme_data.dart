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
      // Matches manifest.json colors and background color.
      primaryColor: colorScheme.primary,
      backgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        textTheme: textTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
        brightness: colorScheme.brightness,
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primaryVariant,
        selectionColor: colorScheme.primaryVariant,
        selectionHandleColor: colorScheme.primaryVariant,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          lightFillColor.withOpacity(0.80),
          darkFillColor,
        ),
        contentTextStyle: textTheme.subtitle1!.apply(color: darkFillColor),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 1,
        contentPadding: EdgeInsets.all(5.0),
        alignLabelWithHint: true
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        margin: EdgeInsets.zero,
      )
    );
  }

  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: const Color(0xFFFDD329), /* lightPaletteColors['yellow']! */
    primaryVariant: const Color(0xFFF7B61C), /* lightPaletteColors['crispYellow']! */
    secondary: const Color(0xFFFFAE2A), /* lightPaletteColors['orange']! */
    secondaryVariant: const Color(0xFFFF872A), /* lightPaletteColors['deeperOrange']! */
    surface: const Color(0xFFFFFAD8), /* lightPaletteColors['cream']! */
    background: const Color(0xFFFFFAD8), /* lightPaletteColors['cream']! */
    error: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: _lightFillColor,
    brightness: Brightness.light
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
    button: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 14.0),
  );
}