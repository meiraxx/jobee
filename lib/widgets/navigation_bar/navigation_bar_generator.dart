import 'package:flutter/material.dart';

import 'custom_bottomNavigationBar.dart';
import 'custom_bottomNavigationBarItem.dart';

Widget bottomNavigationBarGenerator({ required BuildContext context, required Function(int) onTap,
  required int bottomNavigationCurrentIndex, required List<Widget> inactiveIconList, required List<Widget> activeIconList,
  required List<String> labelList, required int nItems, required Color inactiveColor }) {
  /// Function to help generating a BottomNavigationBar for any context.
  ///
  /// @returns a BottomNavigationBar.

  // verify all lists have only 'nItems' elements each
  assert(inactiveIconList.length == nItems); // verify inactiveIconList only has 'nItems' elements
  assert(activeIconList.length == nItems); // verify activeIconList only has 'nItems' elements
  assert(labelList.length == nItems); // verify labelList only has 'nItems' elements

  Color activeColor = Theme.of(context).colorScheme.primary;

  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      boxShadow: [
        BoxShadow(
          color: inactiveColor,
        ),
      ],
    ),
    child: CustomBottomNavigationBar(
      onTap: onTap,
      currentIndex: bottomNavigationCurrentIndex,
      backgroundColor: Theme.of(context).colorScheme.background,
      type: CustomBottomNavigationBarType.fixed,
      selectedFontSize: 12.0,
      unselectedFontSize: 11.0,
      elevation: 8.0,
      items: <CustomBottomNavigationBarItem>[
        for (var i = 0; i < labelList.length; i+=1) CustomBottomNavigationBarItem(
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
    ),
  );
}

