import 'package:flutter/material.dart';
import 'slide_navbar.dart';
import 'bottom_nav.dart'; // ✅ Import bottom navigation

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Lancer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  final titles = const [
    'Home',
    'Search',
    'Favorites',
    'Profile',
  ];

  void onSelectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
    Navigator.of(context).pop(); // Close the drawer after selecting
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[selectedIndex])),
      drawer: SlideNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: onSelectPage,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() => selectedIndex = index);
        },
        children: const [
          Center(child: Text('Home Page', style: TextStyle(fontSize: 36))),
          Center(child: Text('Search Page', style: TextStyle(fontSize: 36))),
          Center(child: Text('Favorites Page', style: TextStyle(fontSize: 36))),
          Center(child: Text('Profile Page', style: TextStyle(fontSize: 36))),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        pageController: pageController,
        onItemSelected: (index) {
          setState(() => selectedIndex = index);
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad,
          );
        },
      ),
    );
  }
}
