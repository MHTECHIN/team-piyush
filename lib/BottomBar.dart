import 'package:flutter/material.dart';
import 'package:glow_bottom_app_bar/glow_bottom_app_bar.dart'; // Make sure this is the correct package

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GlowBottomAppBar(
        height: 60,
        onChange: (value) {
          print(value);
        },
        background: Colors.black54,
        iconSize: 35,
        glowColor: Colors.redAccent,
        selectedChildren: const [
          Icon(Icons.ac_unit, color: Colors.redAccent),
          Icon(Icons.adb_rounded, color: Colors.redAccent),
          Icon(Icons.account_circle_rounded, color: Colors.redAccent),
        ],
        children: const [
          Icon(Icons.ac_unit, color: Colors.white),
          Icon(Icons.adb_rounded, color: Colors.white),
          Icon(Icons.account_circle_rounded, color: Colors.white),
        ],
      ),
    );
  }
}
