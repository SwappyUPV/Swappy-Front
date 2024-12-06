import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarItemWidget {
  static Widget buildNavBarItem(String icon, int index, int selectedIndex, Function(int) onItemTapped) {
    final bool isSelected = selectedIndex == index;
    return IconButton(
      icon: SvgPicture.asset(
        'assets/icons/navBar/${isSelected ? '${icon}_selected' : icon}.svg',
        width: 30,
        height: 30,
        color: isSelected ? Colors.black : Colors.black.withOpacity(0.9),
      ),
      onPressed: () => onItemTapped(index),
    );
  }
}