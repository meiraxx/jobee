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
  "yellow": const Color(0xFFFDD329), /* primary: yellow */
  "crispYellow": const Color(0xFFF7B61C), /* primaryVariant: crispYellow */
  "cream": const Color(0xFFFFFAD8), /* secondary: cream */
  "orange": const Color(0xFFFFAE2A),/* secondaryVariant: orange */
  "lightGray": const Color(0xFFF6F6F4), /* onPrimary/onError: lightGray */
  "error": const Color(0xFFB00020), /* used for errors */
  "white": Colors.white, /* white */
  "black": Colors.black, /* black */
};

ButtonStyle orangeElevatedButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) => lightPaletteColors["crispYellow"]),
  overlayColor: MaterialStateProperty.all(lightPaletteColors["yellow"]!.withAlpha(0x5F)),
  elevation: MaterialStateProperty.all(2.0),
  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
);

// appBarButton stuff
final Color appbarDefaultButtonSplashColor = const Color(0xFFB25C36).withAlpha(0x1F);

Widget appBarButton({ String? text, IconData? iconData, Image? image, BuildContext? context,
  Color splashColor = Colors.transparent, double splashRadius = Material.defaultSplashRadius - 5.0,
  String? tooltip, required Color color, required Function() onPressedFunction }) {
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
          textAlign: TextAlign.left,
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
          style: TextStyle(color: color),
          textAlign: TextAlign.left,
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
        tooltip: tooltip,
        highlightColor: splashColor,
        splashColor: splashColor,
        splashRadius: splashRadius,
        onPressed: onPressedFunction,
      );
    }
  }

  return Container();
}

class InPlaceLoader extends StatelessWidget {
  final Size replacedWidgetSize;
  final double submissionErrorHeight;

  const InPlaceLoader({Key? key, required this.replacedWidgetSize, required this.submissionErrorHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: submissionErrorHeight),
      child: SizedBox(
        height: replacedWidgetSize.height - submissionErrorHeight*2,
        width: replacedWidgetSize.width - submissionErrorHeight*2,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(lightPaletteColors["crispYellow"]!),
        ),
      ),
    );
  }

  // waiting 1-3 seconds showing the loading widget animation is recommended because
  // it looks neater than an almost-instant animation
  static Future<void> minimumLoadingSleep(Duration duration) async => await Future.delayed(duration);
}

BottomNavigationBar bottomNavigationBarGenerator({ required BuildContext context, required Function(int) onTap,
  required int bottomNavigationCurrentIndex, required List<IconData> iconDataList,
  Color activeColor = const Color(0xFF2196F3), Color inactiveColor = const Color(0xFF757575) }) {
  /// Function to help generating a BottomNavigationBar for any context.
  ///
  /// @returns a BottomNavigationBar.

  assert(iconDataList.length == 3); // verify iconDataList only has 3 elements

  return BottomNavigationBar(
    onTap: onTap,
    currentIndex: bottomNavigationCurrentIndex,
    backgroundColor: Colors.grey[50],
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          iconDataList[0],
          //color: firstNavItemColor
        ),
        /*title: Text(
          'Home',
          style: TextStyle(
            color: firstNavItemColor
          ),
        ),*/
        label: 'Home',
        tooltip: 'Home'
      ),
      BottomNavigationBarItem(
        icon: Icon(
          iconDataList[1],
          //color: secondNavItemColor
        ),
        /*title: Text(
          'Profile',
          style: TextStyle(
            color: secondNavItemColor
          ),
        ),*/
        label: 'Profile',
        tooltip: 'Profile'
      ),
      BottomNavigationBarItem(
        icon: Icon(
          iconDataList[2],
          //color: thirdNavItemColor
        ),
        /*title: Text(
          'Chat',
          style: TextStyle(
              color: thirdNavItemColor
          ),
        ),*/
        label: 'Chat',
        tooltip: 'Chat'
      ),
    ],
    unselectedLabelStyle: TextStyle(
      color: inactiveColor,
    ),
    selectedLabelStyle: TextStyle(
      color: activeColor,
    ),
    unselectedItemColor: inactiveColor,
    selectedItemColor: activeColor,
    unselectedIconTheme: IconThemeData(color: inactiveColor),
    selectedIconTheme: IconThemeData(color: activeColor),
  );
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key? key, required this.onChildSize, required this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  /// Class to be used for retrieving widget sizes:
  /// - Useful for debugging sizes
  /// - Useful for calculating new sizes
  ///
  /// Note: if needed, wrap the SizeProviderWidget with an OrientationBuilder widget
  /// to make it respect the orientation of the device

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}