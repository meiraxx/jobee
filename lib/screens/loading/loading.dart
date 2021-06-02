import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jobee/shared/constants.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void doSomething() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/wrapper');
  }

  @override
  void initState() {
    super.initState();
    doSomething();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: paletteColors["cream"],
        body: Padding(
          padding: EdgeInsets.all(50.0),
          child: Center(
            child: SpinKitFadingCube(
              color: paletteColors["orange"],
              size: 75.0,
            ),
          ),
        )
    );
  }
}
