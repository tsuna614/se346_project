import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/app-screens/profile/edit_profile_screen.dart';
import 'package:se346_project/src/widgets/post.dart';

import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/addPostScreen.dart';

class ProfileScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const ProfileScreen({Key? key, required this.alternateDrawer})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfileData?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = GeneralAPI().loadCurrentUserProfile();
  }

  void _refreshProfile() async {
    setState(() {
      _profileFuture = GeneralAPI().loadCurrentUserProfile();
    });
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
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () async {
                  // wait for pop to refresh the profile
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                              future: _profileFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        'Error loading user profile. Error: ${snapshot.error}.'),
                                  );
                                } else {
                                  UserProfileData user =
                                      snapshot.data as UserProfileData;
                                  return EditProfileScreen(user);
                                }
                              },
                            )),
                  );

                  _refreshProfile();
                },
              ),
            ],
            expandedHeight: 50.0,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Error loading user profile. Error: ${snapshot.error}.'),
                  );
                } else {
                  UserProfileData user = snapshot.data as UserProfileData;
                  print('user is poster? ${user.posts?.first.userIsPoster}');
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: user.profileBackground != null &&
                                    user.profileBackground!.isNotEmpty
                                ? FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: user.profileBackground!)
                                    .image
                                : MemoryImage(kTransparentImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            ClipPath(
                              clipper: BezierClipper(),
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: user.avatarUrl != null &&
                                            user.avatarUrl!.isNotEmpty
                                        ? FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image: user.avatarUrl!)
                                            .image
                                        : MemoryImage(kTransparentImage),
                                  ),
                                ],
                              ),
                            ),
                            Text(user.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            Text(user.bio ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal)),
                            Text(
                              'Followers: ${user.followers?.length ?? 0}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
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
                            Spacer(),
                            IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Colors.green),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddPostScreen()),
                                  );
                                  if (result == true) {
                                    _refreshProfile();
                                  }
                                }),
                          ],
                        ),
                      ),
                      if (user.posts != null)
                        for (var post in user.posts!)
                          Post(
                            postData: post,
                            refreshPreviousScreen: _refreshProfile,
                          ),
                      SizedBox(height: 20),
                      Center(
                        child: Text('No more posts available',
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
