import 'package:flutter/material.dart';
import 'dart:math' as math;

const Map<String, Color> paletteColors = {
  "cream": const Color(0xFFF5F1D4),
  "yellow1": const Color(0xFFFFCF26),
  "yellow2": const Color(0xFFFCAB15),
  "orange": const Color(0xFFFF853E),
  "brown": const Color(0xFFB25C36)
};

ButtonStyle orangeElevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) => paletteColors["orange"]),
    overlayColor: MaterialStateProperty.all(paletteColors["yellow1"]!.withAlpha(0x5F))
);

const InputDecoration textInputDecoration = InputDecoration(
  errorMaxLines: 1,
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.white,
        width: 2.0
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: const Color(0xFFFF853E),
        width: 3.0
    ),
  ),
);

Widget appBarButton({ String? text, IconData? iconData, Image? image, BuildContext? context,
  Color splashColor = Colors.transparent, double splashRadius = Material.defaultSplashRadius - 5.0,
  required Color color, required Function() onPressedFunction }) {
  assert(text!=null || iconData!=null || image != null);
  // in case image isn't null, we also need the context
  if (image != null) {
    assert(context!=null);
  }

  if (text != null) {
    if (iconData != null) {
      // IconText button
      return TextButton.icon(
        icon: Icon(
          iconData,
          color: color,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(splashColor),
        ),
        onPressed: onPressedFunction,
      );
    } else if (image != null) {
      // ImageText Button
      return Center(
        child: InkWell(
          onTap: () {
            onPressedFunction();
          },
          overlayColor: MaterialStateProperty.all(splashColor),
          highlightColor: splashColor,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 20.0
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: image,
                ),
                SizedBox(width: 6.0),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // TextButton
      return TextButton(
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(splashColor),
        ),
        onPressed: onPressedFunction,
      );
    }
  } else {
    if (iconData != null) {
      // IconButton
      return IconButton(
        icon: Icon(
          iconData,
          color: color,
        ),
        highlightColor: splashColor,
        splashColor: splashColor,
        splashRadius: splashRadius,
        onPressed: onPressedFunction,
      );
    }
  }

  return Container();
}

BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
  backgroundColor: Colors.grey[50],
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chat',
    ),
  ],
);