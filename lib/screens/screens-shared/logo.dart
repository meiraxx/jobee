import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/utils/math_utils.dart';

// Logo Class
class Logo extends StatefulWidget {
  @override
  _LogoState createState() => new _LogoState();
}

class _LogoState extends State<Logo> {
  static Color _currentLogoColor = Colors.black;
  static int _currentLogoIndex = -1;

  // - FUNCTIONS
  Future logoInteractions(BuildContext context, Color defaultLogoColor, int interaction) async {
    final List<Color> logoColorList = [
      // - RGB
      Colors.red,
      Colors.green,
      Colors.blue,
      // - Themed ColorScheme
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.primaryVariant,
      // - Others, ordered on material.io/design/color
      Colors.pink,
      Colors.purple,
      //Colors.deepPurple,
      //Colors.indigo,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.lightGreen,
      //Colors.lime,
      //Colors.yellow,
      //Colors.amber,
      //Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      //Colors.grey,
      Colors.blueGrey,
    ];
    if (interaction == 1) {
      // - INTERACTION 1: toggle between logo's default and a random color
      if (_currentLogoColor == defaultLogoColor) {
        _currentLogoIndex = generateDifferentRandomInteger(0, logoColorList.length, _currentLogoIndex);
        _currentLogoColor = logoColorList[_currentLogoIndex];
      } else {
        _currentLogoColor = defaultLogoColor;
      }
      if (this.mounted) setState(() {});
    } else if (interaction == 2) {
      // - INTERACTION 2: toggle between logo's random colors
      _currentLogoIndex = generateDifferentRandomInteger(0, logoColorList.length, _currentLogoIndex);
      _currentLogoColor = logoColorList[_currentLogoIndex];
      if (this.mounted) setState(() {});
    } else if (interaction == 3) {
      // - INTERACTION 3: make the whole logo disappear!
      if (_currentLogoColor == defaultLogoColor) {
        _currentLogoColor = Colors.transparent;
      } else {
        _currentLogoColor = defaultLogoColor;
      }
      if (this.mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // - WIDGETS
    return GestureDetector(
      onTap: () async {
        logoInteractions(context, Colors.black, 1);
      },
      onDoubleTap: () async {
        logoInteractions(context, Colors.black, 2);
      },
      onHorizontalDragStart: (dragStartDetails) async {
        logoInteractions(context, Colors.black, 3);
      },
      child: Tooltip(
        message: 'jobee logo!',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              "images/bee-logo-07.png",
              semanticLabel: "Jobee logo",
              width: 32.0, // default icon width
              height: 32.0, // default icon height
              color: _currentLogoColor
            ),
            SizedBox(width: 4.0),
            Text(
              "jobee",
              style: GoogleFonts.museoModerno().copyWith(
                // COOL logo font families:
                // - MuseoModerno
                // - Srisakdi
                color: _currentLogoColor,
                fontSize: 18,
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
      ),
    );
  }
}