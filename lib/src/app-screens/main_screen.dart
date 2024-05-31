import 'package:flutter/material.dart';
import 'package:se346_project/src/app-screens/drawer_screen.dart';
import 'package:se346_project/src/app-screens/media/home_screen.dart';
import 'package:se346_project/src/app-screens/profile/profile_screen.dart';
import 'package:se346_project/src/app-screens/friends/friends_screen.dart';
import 'package:se346_project/src/app-screens/social/social_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  final String appName = 'Notfacebook';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Widget appScreen;

  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  void switchScreen(int screenIndex) {
    setState(() {
      xOffset = MediaQuery.of(context).size.width + 100;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        switch (screenIndex) {
          case 0:
            appScreen = HomeScreen(
              alternateDrawer: alternateDrawer,
              appName: widget.appName,
            );
            break;
          case 1:
            appScreen = SocialScreen(
              alternateDrawer: alternateDrawer,
            );
            break;
          case 2:
            appScreen = ProfileScreen(
              alternateDrawer: alternateDrawer,
            );
            break;
          case 3:
            appScreen = FriendsScreen(
              alternateDrawer: alternateDrawer,
            );
            break;
          default:
            appScreen = HomeScreen(
              alternateDrawer: alternateDrawer,
              appName: widget.appName,
            );
        }
        xOffset = 290;
      });
    });
  }

  void alternateDrawer() {
    isDrawerOpen
        ? setState(() {
            xOffset = 0;
            yOffset = 0;
            isDrawerOpen = false;
          })
        : setState(() {
            xOffset = 290;
            yOffset = 80;
            isDrawerOpen = true;
          });
  }

  @override
  void initState() {
    //Todo: change back later
    appScreen = HomeScreen(
      alternateDrawer: alternateDrawer,
      appName: widget.appName,
    );
    // appScreen = ProfileScreen(
    //   alternateDrawer: alternateDrawer,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DrawerScreen(switchScreen: switchScreen),
        AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(isDrawerOpen ? 0.85 : 1.00),
          duration: Duration(milliseconds: 200),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: isDrawerOpen
          //       ? BorderRadius.circular(40)
          //       : BorderRadius.circular(0),
          // ),
          child: ClipRRect(
            borderRadius: isDrawerOpen
                ? BorderRadius.circular(40)
                : BorderRadius.circular(0),
            child: GestureDetector(
              onTap: () {
                if (isDrawerOpen) {
                  alternateDrawer();
                }
              },
              child: Scaffold(
                extendBodyBehindAppBar: true,
                body: Stack(
                  children: [
                    appScreen,
                  ],
                ),
              ),
            ),
          ),
        ),
        // gesture detector for swiping to the right to open the drawer
        Positioned(
          left: 0,
          child: GestureDetector(
            onPanEnd: (details) {
              // Swiping in right direction.
              if (details.velocity.pixelsPerSecond.dx > 0 && !isDrawerOpen) {
                alternateDrawer();
              }
            },
            child: Container(
              width: 20,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
        ),
        // gesture detector for swiping to the left to close the drawer
        Positioned(
          right: 0,
          child: GestureDetector(
            onPanEnd: (details) {
              // Swiping in left direction.
              if (details.velocity.pixelsPerSecond.dx < 0 && isDrawerOpen) {
                alternateDrawer();
              }
            },
            child: Container(
              width: 20,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
