import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jobee/shared/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightPaletteColors["cream"],
      child: Center(
        child: SpinKitChasingDots(
          color: lightPaletteColors["orange"],
          size: 50.0,
        ),
      ),
    );
  }
}
