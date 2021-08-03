import 'package:flutter/material.dart';
import 'package:jobee/screens/theme/jobee_theme_data.dart' show JobeeThemeData;
import 'package:jobee/screens/widgets/custom_material_widgets/ink_splash/custom_elevated_button_ink_splash.dart' show CustomElevatedButtonInkSplash;

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final void Function() onClicked;

  const ElevatedButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButtonTheme(
    data: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1.0,
        shape: const StadiumBorder(),
        onPrimary: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ).copyWith(
        overlayColor: MaterialStateProperty.all( JobeeThemeData.lightPaletteColors["yellow"]!.withAlpha(0x7F) ),
        splashFactory: CustomElevatedButtonInkSplash.splashFactory,
      ),
    ),
    child: ElevatedButton(
      onPressed: onClicked,
      child: Text(text),
    ),
  );
}