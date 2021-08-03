import 'package:flutter/material.dart';

Widget appBarButton({ required BuildContext context, String? text, IconData? iconData, Image? image,
  String? tooltip, Color? color, required Function() onClicked }) {
  assert(text!=null || iconData!=null || image != null);
  
  if (text != null) {
    if (iconData != null) {
      color ??= Theme.of(context).colorScheme.onBackground;
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
        onPressed: onClicked,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all( Theme.of(context).colorScheme.primary ),
        ),
      );
    } else if (image != null) {
      // ImageText Button
      return Center(
        child: InkWell(
          onTap: () {
            onClicked();
          },
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
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
                const SizedBox(width: 6.0),
                Text(
                  text,
                  style: const TextStyle(
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
        onPressed: onClicked,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: color,
          ),
        ),
      );
    }
  } else {
    color ??= Theme.of(context).colorScheme.onPrimary;
    if (iconData != null) {
      // IconButton
      return IconButton(
        icon: Icon(
          iconData,
        ),
        tooltip: tooltip,
        color: color,
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
        splashRadius: 20.0,
        onPressed: onClicked,
      );
    }
  }

  return Container();
}
