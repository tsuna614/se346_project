import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:se346_project/src/provider/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const ProfileScreen({super.key, required this.alternateDrawer});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTab = 0;
  dynamic userData;

  @override
  void initState() {
    userData = {
      'userId': Provider.of<UserProvider>(context, listen: false).userId,
      'email': Provider.of<UserProvider>(context, listen: false).userEmail,
      'name': Provider.of<UserProvider>(context, listen: false).userName,
      'profileImagePath':
          Provider.of<UserProvider>(context, listen: false).avatarUrl,
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.alternateDrawer,
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          _buildProfileScreenContent(),
          Positioned(
            top: 0,
            child: Column(
              children: [
                SizedBox(height: 50),
                Container(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border:
                    // only bottom border
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: CustomClipPathPurple(context: context),
            child: Container(
              color: const Color(0xFF053555),
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          ClipPath(
            clipper: CustomClipPathPurpleAccent(context: context),
            child: Container(
              color: Color.fromARGB(255, 5, 32, 47),
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      if (!userData['profileImagePath'].isEmpty)
                        CircleAvatar(
                          backgroundImage: Image.network(
                            userData['profileImagePath'],
                          ).image,
                        )
                      else
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Text(
                    userData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  userData['email'],
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                          },
                          child: Text(
                            "Stats",
                            style: TextStyle(
                              color: selectedTab == 0
                                  ? const Color(0xFF053555)
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 3,
                          width: selectedTab == 0 ? 30 : 0,
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? const Color(0xFF053555)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: Text(
                            "Friends",
                            style: TextStyle(
                              color: selectedTab == 1
                                  ? const Color(0xFF053555)
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 3,
                          width: selectedTab == 1 ? 30 : 0,
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? const Color(0xFF053555)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 10,
            child: IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ChangeProfileScreen(
                //       name: userData['name'],
                //       email: userData['email'],
                //       avatarUrl: userData['profileImagePath'],
                //     ),
                //   ),
                // );
                // .then((value) {
                //   Future.delayed(Duration(seconds: 1), () {
                //     request();
                //   });
                // });
              },
              icon: Icon(
                FontAwesomeIcons.pencil,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.black.withOpacity(0.8),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              color: Colors.white,
              // add shadow to icon
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreenContent() {
    return Align(
      alignment: const Alignment(0, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            if (selectedTab == 0)
              const Text("No stats found")
            else
              const Text("No friends found"),
          ],
        ),
      ),
    );
  }
}

class CustomClipPathPurple extends CustomClipper<Path> {
  CustomClipPathPurple({required this.context});

  final BuildContext context;

  @override
  Path getClip(Size size) {
    // print(size);
    // double w = size.width;
    // double h = size.height;

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final path = Path();

    // path.moveTo(0, 0);
    // path.lineTo(w * 0.5, h * 0.0);
    // path.lineTo(w * 0.85, h * 0.12);
    // path.lineTo(w, h * 0.12);

    path.moveTo(0, 0);
    path.lineTo(0, h * 0.05);
    path.lineTo(w, h * 0.2);
    // path.quadraticBezierTo(w * 0.1, h * 0.12, w * 0.5, h * 0.08);
    // path.quadraticBezierTo(w * 0.8, h * 0.05, w, h * 0.11);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomClipPathPurpleAccent extends CustomClipper<Path> {
  CustomClipPathPurpleAccent({required this.context});

  final BuildContext context;

  @override
  Path getClip(Size size) {
    // print(size);
    // double w = size.width;
    // double h = size.height;

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, h * 0.2);
    path.lineTo(w, h * 0.05);

    // path.quadraticBezierTo(w * 0.1, h * 0.1, w * 0.7, h * 0.12);
    // path.quadraticBezierTo(w * 1, h * 0.13, w, h * 0.08);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
