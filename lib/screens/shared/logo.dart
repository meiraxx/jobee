import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/shared/constants.dart';

// Logo Class
class Logo extends StatefulWidget {
  @override
  _LogoState createState() => new _LogoState();
}

class _LogoState extends State<Logo> {
  static Color _currentLogoColor = Colors.black;
  static final List<Color> _logoRandomColorList = [
    // - RGB
    Colors.red,
    Colors.green,
    Colors.blue,
    // - Others, ordered on material.io/design/color
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  // - FUNCTIONS
  void logoInteractions(Color defaultLogoColor, int interaction, List<Color> logoColorList) {
    if (interaction == 1) {
      // - INTERACTION 1: toggle between logo's default and a random color
      setState(() {
        if (_currentLogoColor == defaultLogoColor) {
          _currentLogoColor = logoColorList[generateRandomInteger(0, logoColorList.length - 1)];
        } else {
          _currentLogoColor = defaultLogoColor;
        }
      });
    } else if (interaction == 2) {
      // - INTERACTION 2: toggle between logo's random colors
      setState(() {
        _currentLogoColor = logoColorList[generateRandomInteger(0, logoColorList.length - 1)];
      });
    } else if (interaction == 3) {
      // - INTERACTION 3: make the whole logo disappear!
      setState(() {
        if (_currentLogoColor == defaultLogoColor) {
          _currentLogoColor = Colors.transparent;
        } else {
          _currentLogoColor = defaultLogoColor;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // - WIDGETS
    return GestureDetector(
      onTap: () {
        logoInteractions(Colors.black, 1, _logoRandomColorList);
      },
      onDoubleTap: () {
        logoInteractions(Colors.black, 2, _logoRandomColorList);
      },
      onHorizontalDragStart: (dragStartDetails) {
        logoInteractions(Colors.black, 3, _logoRandomColorList);
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