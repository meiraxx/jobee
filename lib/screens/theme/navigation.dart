import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<Widget> _buildPageAsync(Widget page) async {
  return Future<Widget>.microtask(() {
    return page;
  });
}

// SLIDE FROM RIGHT

Future<void> slideFromRightNavigatorPush(BuildContext context, Widget page) async {
  Navigator.push(
    context,
    PageRouteBuilder<dynamic>(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        const Offset begin = Offset(1.0, 0.0);
        const Offset end = Offset.zero;
        final Curve curve = Curves.easeOut;
        final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future<void> slideFromRightNavigatorPushReplacement(BuildContext context, Widget page) async {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder<dynamic>(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        const Offset begin = Offset(1.0, 0.0);
        const Offset end = Offset.zero;
        final Curve curve = Curves.easeOut;
        final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

// SLIDE FROM LEFT
Future<void> slideFromLeftNavigatorPush(BuildContext context, Widget page) async {
  Navigator.push(
    context,
    PageRouteBuilder<dynamic>(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        const Offset begin = Offset(-1.0, 0.0);
        const Offset end = Offset.zero;
        final Curve curve = Curves.easeOut;
        final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future<void> slideFromLeftNavigatorPushReplacement(BuildContext context, Widget page) async {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder<dynamic>(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        const Offset begin = Offset(1.0, 0.0);
        const Offset end = Offset(0.0, 0.0);
        final Curve curve = Curves.easeOut;
        final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    ),
  );
}