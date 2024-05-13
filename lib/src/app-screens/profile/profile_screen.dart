import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/widgets/post.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const ProfileScreen({Key? key, required this.alternateDrawer})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<dynamic>> _loadUser() async {
    String jsonString = await rootBundle.loadString('assets/user_profile.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    // 0 = id, 1 = name , 2 = email, 3 = phone, 4 = avatarUrl, 5 = bio, 6 = posts
    String id = jsonData['id'];
    String name = jsonData['name'];
    String email = jsonData['email'];
    String phone = jsonData['phone'];
    String avatarUrl = jsonData['avatarUrl'];
    String profileBackground = jsonData['profileBackground'];
    String bio = jsonData['bio'];
    List<dynamic> posts = jsonData['posts'];
    return [id, name, email, phone, avatarUrl, bio, posts, profileBackground];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.green),
              onPressed: widget.alternateDrawer,
            ),
            //Todo: implement check if user is the same as the logged in user
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  //Todo implement edit profile
                },
              ),
            ],
            expandedHeight: 50.0,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: _loadUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Error loading user profile. Error: ${snapshot.error}'),
                  );
                } else {
                  List<dynamic> user = snapshot.data as List<dynamic>;
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: double.infinity,
                        //Add background profile image
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: user[7])
                                .image,
                            fit: BoxFit.cover,
                          ),
                        ),

                        child: ClipPath(
                          clipper: BezierClipper(),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: user[4])
                                    .image,
                              ),
                              Text(user[1],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text(user[5],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                      //Posts label
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Posts',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            //Add post button
                            Spacer(),
                            IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Colors.green),
                                onPressed: () {
                                  //Todo implement add post
                                }),
                          ],
                        ),
                      ),

                      for (var post in user[6])
                        Post(
                          id: post['id'],
                          name: user[1],
                          content: post['content'],
                          comments: post['comments'],
                          avatarUrl: user[4],
                          mediaUrl:
                              post.containsKey('media') ? post['media'] : null,
                        ),
                      SizedBox(height: 20),
                      Center(
                        child: Text('No more post available',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal)),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// Create a custom clipper class to create a bezier curve
class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
