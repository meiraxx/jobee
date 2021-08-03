import 'package:flutter/material.dart';

/*
void openDropdownMethod1(GlobalKey dropdownButtonKey) {
  dropdownButtonKey.currentContext!.visitChildElements((element) {
    if (element.widget is Semantics) {
      element.visitChildElements((element) {
        debugPrint("hello1");
        debugPrint(element);
        if (element.widget is Actions) {
          element.visitChildElements((element) {
            debugPrint("hello");
            debugPrint(element);
          });
        }
      });
    }
  });
}*/

void openDropdownMethod2(GlobalKey dropdownButtonKey) {
  GestureDetector? detector;
  void searchForGestureDetector(BuildContext element) {
    element.visitChildElements((Element element) {
      if (element.widget is GestureDetector) {
        detector = element.widget as GestureDetector?;
      } else {
        searchForGestureDetector(element);
      }
    });
  }

  searchForGestureDetector(dropdownButtonKey.currentContext!);
  assert(detector != null);

  detector!.onTap!();
}