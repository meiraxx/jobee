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

Widget appBarButton({ String? text, IconData? iconData, required Color color, required Function() onPressedFunction }) {
  assert(text!=null || iconData!=null);

  // only TextButton
  if ( iconData == null && text != null ) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(paletteColors["brown"]!.withAlpha(0x1F)),
      ),
      onPressed: onPressedFunction,
    );
  }

  // only IconButton
  if ( text == null && iconData != null ) {
    return IconButton(
      icon: Icon(
        iconData,
        color: color,
      ),
      highlightColor: paletteColors["brown"]!.withAlpha(0x1F),
      splashColor: paletteColors["brown"]!.withAlpha(0x1F),
      onPressed: onPressedFunction,
    );
  }

  // if all arguments are provided
  return TextButton.icon(
    icon: Icon(
      iconData,
      color: color,
    ),
    label: Text(
      text!,
      style: TextStyle(color: color),
    ),
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(paletteColors["brown"]!.withAlpha(0x1F)),
    ),
    onPressed: onPressedFunction,
  );
}

ButtonStyle orangeElevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) => paletteColors["orange"]),
    overlayColor: MaterialStateProperty.all(paletteColors["yellow1"]!.withAlpha(0x5F))
);