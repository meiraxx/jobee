import 'package:flutter/material.dart';

const Map<String, Color> paletteColors = {
  "cream": const Color(0xFFF5F1D4),
  "yellow1": const Color(0xFFFFCF26),
  "yellow2": const Color(0xFFFCAB15),
  "orange": const Color(0xFFFF853E),
  "brown": const Color(0xFFB25C36)
};


const InputDecoration textInputDecoration = InputDecoration(
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


TextButton appBarTextIcon(String text, IconData iconData, Color color, Function onPressedFunction) {
  return TextButton.icon(
    icon: Icon(
      iconData,
      color: color,
    ),
    label: Text(
      text,
      style: TextStyle(color: color),
    ),
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(paletteColors["orange"].withAlpha(0x5F)),
    ),
    onPressed: onPressedFunction,
  );
}