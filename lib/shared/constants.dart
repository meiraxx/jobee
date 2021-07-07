import 'package:flutter/material.dart';

// plus black and white
const Map<String, Color> paletteColors1 = {
  "cream": const Color(0xFFF5F1D4),
  "yellow1": const Color(0xFFFFCF26),
  "yellow2": const Color(0xFFFCAB15),
  "orange": const Color(0xFFFF853E),
  "brown": const Color(0xFFB25C36)
};

const Map<String, Color> lightPaletteColors = {
  // Palette Colors
  "cream": const Color(0xFFFFFAD8),
  "orange": const Color(0xFFFFAE2A),
  "deeperOrange": const Color(0xFFFF872A),
  "yellow": const Color(0xFFFDD329),
  "crispYellow": const Color(0xFFF7B61C),
  "lightGray": const Color(0xFFF6F6F4),
  // More Colors
  "error": const Color(0xFFB00020), /* used for errors */
  "white": Colors.white, /* white */
  "black": Colors.black, /* black */
};

ButtonStyle orangeElevatedButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) => lightPaletteColors["orange"]),
  overlayColor: MaterialStateProperty.all(lightPaletteColors["yellow"]!.withAlpha(0x7F)),
  elevation: MaterialStateProperty.all(2.0),
  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
  animationDuration: Duration(milliseconds: 300),
);

Widget appBarButton({ String? text, IconData? iconData, Image? image, BuildContext? context,
  String? tooltip, required Function() onPressedFunction }) {
  assert(text!=null || iconData!=null || image != null);
  // in case image isn't null, we also need the context
  if (image != null || (text!=null && iconData!=null)) {
    assert(context!=null);
  }

  if (text != null) {
    if (iconData != null) {
      // IconText button
      return TextButton.icon(
        icon: Icon(
          iconData,
          color: Theme.of(context!).colorScheme.onPrimary,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
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
          textAlign: TextAlign.left,
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
        ),
        tooltip: tooltip,
        onPressed: onPressedFunction,
      );
    }
  }

  return Container();
}

