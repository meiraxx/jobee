import 'package:flutter/material.dart';

BottomNavigationBar bottomNavigationBarGenerator({ required BuildContext context, required Function(int) onTap,
  required int bottomNavigationCurrentIndex, required List<IconData> inactiveIconDataList, required List<IconData> activeIconDataList,
  Color inactiveColor = const Color(0xFF757575) }) {
  /// Function to help generating a BottomNavigationBar for any context.
  ///
  /// @returns a BottomNavigationBar.

  assert(inactiveIconDataList.length == 3); // verify inactiveIconDataList only has 3 elements
  assert(activeIconDataList.length == 3); // verify inactiveIconDataList only has 3 elements

  Color activeColor = Theme.of(context).colorScheme.primary;

  return BottomNavigationBar(
    onTap: onTap,
    currentIndex: bottomNavigationCurrentIndex,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          inactiveIconDataList[0],
        ),
        activeIcon: Icon(
          activeIconDataList[0],
        ),
        label: 'Home',
        tooltip: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          inactiveIconDataList[1],
        ),
        activeIcon: Icon(
          activeIconDataList[1],
        ),
        label: 'Profile',
        tooltip: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          inactiveIconDataList[2],
        ),
        activeIcon: Icon(
          activeIconDataList[2],
        ),
        label: 'Chat',
        tooltip: 'Chat',
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