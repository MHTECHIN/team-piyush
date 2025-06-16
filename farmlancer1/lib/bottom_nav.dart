import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterDropNavBar(
      backgroundColor: Colors.white,
      waterDropColor: Colors.blueAccent,
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        onItemSelected(index);
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      },
      barItems: [
        BarItem(
          filledIcon: Icons.home_rounded,
          outlinedIcon: Icons.home_outlined,
        ),
        BarItem(
          filledIcon: Icons.search_rounded,
          outlinedIcon: Icons.search_outlined,
        ),
        BarItem(
          filledIcon: Icons.favorite_rounded,
          outlinedIcon: Icons.favorite_border_rounded,
        ),
        BarItem(
          filledIcon: Icons.person_rounded,
          outlinedIcon: Icons.person_outline,
        ),
      ],
    );
  }
}
