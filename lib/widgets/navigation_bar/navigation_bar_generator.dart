import 'package:flutter/material.dart';

import 'custom_animated_bottom_bar.dart';
import 'custom_bottom_navigation_bar.dart';
import 'custom_bottom_navigation_bar_item.dart';

Widget bottomNavigationBarGenerator({ required BuildContext context, required Function(int) onTap,
  required int bottomNavigationCurrentIndex, required List<Widget> activeIconList, required List<Widget> inactiveIconList,
  required List<String> labelList, required int nItems, required Color inactiveColor, required Color activeColor, required int navBarType }) {
  /// Function to help generating a BottomNavigationBar for any context.
  ///
  /// @returns a BottomNavigationBar.

  // verify all lists have only 'nItems' elements each
  assert(inactiveIconList.length == nItems); // verify inactiveIconList only has 'nItems' elements
  assert(activeIconList.length == nItems); // verify activeIconList only has 'nItems' elements
  assert(labelList.length == nItems); // verify labelList only has 'nItems' elements

  late final Widget navigationBarWidget;

  if (navBarType == 1) {
    navigationBarWidget = CustomBottomNavigationBar(
      onTap: onTap,
      currentIndex: bottomNavigationCurrentIndex,
      type: CustomBottomNavigationBarType.fixed,
      selectedFontSize: 12.0,
      unselectedFontSize: 11.0,
      elevation: 8.0,
      items: <CustomBottomNavigationBarItem>[
        for (int i = 0; i < labelList.length; i+=1) CustomBottomNavigationBarItem(
          icon: inactiveIconList[i],
          activeIcon: activeIconList[i],
          label: labelList[i],
          tooltip: '',
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
  } else if (navBarType == 2) {
    navigationBarWidget = CustomAnimatedBottomBar(
      selectedIndex: bottomNavigationCurrentIndex,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: onTap,
      items: <BottomNavyBarItem>[
        for (int i = 0; i < labelList.length; i+=1) BottomNavyBarItem(
          inactiveIcon: inactiveIconList[i],
          activeIcon: activeIconList[i],
          title: Text(labelList[i]),
          inactiveColor: inactiveColor,
          activeColor: activeColor,
        ),
      ],
    );
  } else {
    throw Exception("Specify a valid navBarType (1 or 2)");
  }

  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: inactiveColor,
        ),
      ],
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        brightness: Theme.of(context).colorScheme.brightness,
        splashColor: Colors.grey[100],
        highlightColor: Colors.grey[100],
      ),
      child: navigationBarWidget,
    ),
  );
}

