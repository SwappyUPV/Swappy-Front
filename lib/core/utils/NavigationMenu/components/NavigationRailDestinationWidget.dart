import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationRailDestinationWidget {
  static NavigationRailDestination buildRailDestination(String icon, String selectedIcon, String label, int selectedIndex, List<Widget> pages) {
    final bool isSelected = selectedIndex == pages.indexWhere((element) => element.toString() == label);
    return NavigationRailDestination(
      icon: SvgPicture.asset(
        'icons/navBar/$icon.svg',
        width: 30,
        height: 30,
        color: isSelected ? Colors.black : Colors.black.withOpacity(0.9),
      ),
      selectedIcon: SvgPicture.asset(
        'icons/navBar/$selectedIcon.svg',
        width: 30,
        height: 30,
        color: Colors.black,
      ),
      label: Text(label),
    );
  }
}