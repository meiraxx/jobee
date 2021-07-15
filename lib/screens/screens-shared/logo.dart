import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Logo Class
class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  static Color _currentLogoColor = Colors.black;

  // - FUNCTIONS
  Future<void> logoInteractions(BuildContext context, Color defaultLogoColor, int interaction) async {
    if (interaction == 1) {
      // - INTERACTION 1: toggle between logo's default and a random color
      if (_currentLogoColor == defaultLogoColor) {
        _currentLogoColor = Theme.of(context).colorScheme.secondary;
      } else {
        _currentLogoColor = defaultLogoColor;
      }
      if (this.mounted) setState(() {});
    } else if (interaction == 2) {
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
      onHorizontalDragStart: (DragStartDetails dragStartDetails) async {
        logoInteractions(context, Colors.black, 2);
      },
      child: Tooltip(
        message: 'jobee logo!',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Image.asset(
              "images/bee-logo-07.png",
              semanticLabel: "Jobee logo",
              width: 32.0, // default icon width
              height: 32.0, // default icon height
              color: _currentLogoColor
            ),
            const SizedBox(width: 4.0),
            Text(
              "Jobee",
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