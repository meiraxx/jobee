import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Logo Class
class Logo extends StatefulWidget {
  final void Function() updateWidgetStateCallback;
  final Color defaultLogoColor;

  const Logo({Key? key, required this.updateWidgetStateCallback, required this.defaultLogoColor}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  static late Color _currentLogoColor;

  // - FUNCTIONS
  Future<void> logoInteractions(BuildContext context, int interaction) async {
    if (interaction == 1) {
      // - INTERACTION 1: toggle between logo's default and a random color
      if (_currentLogoColor == widget.defaultLogoColor) {
        _currentLogoColor = Theme.of(context).colorScheme.secondary;
      } else {
        _currentLogoColor = widget.defaultLogoColor;
      }
      if (this.mounted) widget.updateWidgetStateCallback();
    } else if (interaction == 2) {
      // - INTERACTION 3: make the whole logo disappear!
      if (_currentLogoColor == widget.defaultLogoColor) {
        _currentLogoColor = Colors.transparent;
      } else {
        _currentLogoColor = widget.defaultLogoColor;
      }
      if (this.mounted) widget.updateWidgetStateCallback();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentLogoColor = widget.defaultLogoColor;
  }

  @override
  Widget build(BuildContext context) {
    // - WIDGETS
    return GestureDetector(
      onTap: () async {
        logoInteractions(context, 1);
      },
      onHorizontalDragStart: (DragStartDetails dragStartDetails) async {
        logoInteractions(context, 2);
      },
      child: Tooltip(
        message: 'jobee logo!',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/bee-logo-07.png',
              semanticLabel: "Jobee logo",
              width: 32.0, // default icon width
              height: 32.0, // default icon height
              color: _currentLogoColor,
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


