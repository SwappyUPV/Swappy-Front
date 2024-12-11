import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarItemWidget {
  static Widget buildNavBarItem(String icon, int index, int selectedIndex, Function(int) onItemTapped, double iconSize) {
    final bool isSelected = selectedIndex == index;
    return IconButton(
      icon: SvgPicture.asset(
        'icons/navBar/${isSelected ? '${icon}_selected' : icon}.svg',
        width: iconSize,
        height: iconSize,
        color: isSelected ? Colors.black : Colors.black.withOpacity(0.9),
      ),
      onPressed: () => onItemTapped(index),
    );
  }
}