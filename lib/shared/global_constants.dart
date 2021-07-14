import 'package:flutter/material.dart';
import 'package:jobee/theme/jobee_theme_data.dart' show JobeeThemeData;

Widget appBarButton({ required BuildContext context, String? text, IconData? iconData, Image? image,
  String? tooltip, Color? color, required Function() onPressedFunction }) {
  assert(text!=null || iconData!=null || image != null);

  if (color==null) color = Theme.of(context).colorScheme.onPrimary;
  
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
          textAlign: TextAlign.left,
        ),
        onPressed: onPressedFunction,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all( Theme.of(context).colorScheme.primary ),
        ),
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
          style: TextStyle(
            color: color,
          ),
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
        color: color,
        splashColor: JobeeThemeData.darkSplashColor,
        highlightColor: JobeeThemeData.darkHighlightColor,
        splashRadius: iconSplashRadius,
        onPressed: onPressedFunction,
      );
    }
  }

  return Container();
}

// global icon splash radius
double iconSplashRadius = 20.0;
