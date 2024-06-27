import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

final _firebase = FirebaseAuth.instance;

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key, required this.switchScreen});

  final void Function(int index) switchScreen;

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Color.fromARGB(255, 129, 129, 129),
        //       Color.fromARGB(255, 86, 158, 92),
        //       Color.fromARGB(255, 54, 181, 73),
        //     ], // Gradient from https://learnui.design/tools/gradient-generator.html
        //     tileMode: TileMode.mirror,
        //   ),
        // ),
        color: Color(0xFF053555),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  // Image.asset(
                  //   'assets/images/Logo.png',
                  //   height: 100,
                  // ),
                  Text(
                    "DePa",
                    style: GoogleFonts.getFont(
                      'Lobster',
                      fontSize: 60,
                      color: Colors.white,
                    ),
                    // style: TextStyle(
                    //   color: Colors.white,
                    //   fontSize: 30,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  buildAnimatedButton(context, 0),
                  const SizedBox(
                    height: 20,
                  ),
                  buildAnimatedButton(context, 1),
                  const SizedBox(
                    height: 20,
                  ),
                  buildAnimatedButton(context, 2),
                  const SizedBox(
                    height: 20,
                  ),
                  // buildAnimatedButton(context, 3),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // buildAnimatedButton(context, 4),
                ],
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  _dialogBuilder(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.logout,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 20,
                        letterSpacing: 4,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedButton(BuildContext context, int itemIndex) {
    final icon;
    final text;
    switch (itemIndex) {
      case 0:
        icon = FontAwesomeIcons.house;
        text = 'Home';
        break;
      case 1:
        icon = Icons.chat;
        text = 'Chatbot';
        break;
      case 2:
        icon = FontAwesomeIcons.userLarge;
        text = 'Profile';
        break;
      default:
        icon = FontAwesomeIcons.userLarge;
        text = 'Profile';
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.only(
        left: _selectedIndex == itemIndex ? 20 : 0,
      ),
      height: _selectedIndex == itemIndex ? 60 : 50,
      decoration: BoxDecoration(
        color: _selectedIndex == itemIndex
            ? Colors.white.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = itemIndex;
            widget.switchScreen(itemIndex);
          });
        },
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _firebase.signOut();
              },
            ),
          ],
        );
      },
    );
  }
}
