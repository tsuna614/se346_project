import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:se346_project/src/app-screens/bookmarks_screen.dart';
import 'package:se346_project/src/app-screens/categories_screen.dart';
import 'package:se346_project/src/app-screens/design-patterns/design_pattern.dart';

class HomeScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const HomeScreen({
    super.key,
    required this.alternateDrawer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = [
    DesginPatternPage(),
    CategoriesScreen(),
    BookmarksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black.withOpacity(0.03),
      appBar: AppBar(
        // title: const Text('Home'),
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.alternateDrawer,
        ),
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: _buildSalomonBottomBar(),
    );
  }

  Widget _buildSalomonBottomBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: SalomonBottomBar(
          unselectedItemColor: Colors.black.withOpacity(0.2),
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(_selectedIndex,
                  duration: Duration(milliseconds: 1), curve: Curves.linear);
            });
          },
          currentIndex: _selectedIndex,
          // control which tab will be highlighted when chosen
          items: [
            SalomonBottomBarItem(
                icon: Icon(FontAwesomeIcons.book),
                title: Text('Design Patterns'),
                selectedColor: Colors.lightBlue.shade300),
            SalomonBottomBarItem(
              icon: Icon(FontAwesomeIcons.solidFolderOpen),
              title: Text('Categories Details'),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: Icon(FontAwesomeIcons.bookBookmark),
              title: Text('Bookmarks'),
              selectedColor: Colors.brown,
            ),
            // SalomonBottomBarItem(
            //     icon: Icon(FontAwesomeIcons.medal),
            //     title: Text('Leaderboard'),
            //     selectedColor: Colors.yellow.shade700),
          ],
        ),
      ),
    );
  }
}
