import 'package:flutter/material.dart';
import 'package:se346_project/src/app-screens/profile/profile_screen.dart';
import 'package:se346_project/src/widgets/post.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';

class OtherProfile extends StatefulWidget {
  final String uid;
  const OtherProfile({required this.uid});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  Future<UserProfileData?> _loadUser() async {
    try {
      final user = await GeneralAPI().loadOtherProfile(widget.uid);
      return user;
    } catch (e) {
      throw e;
    }
  }

  bool _loadingFollow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            floating: true,
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
                        'Error loading user profile. Error: ${snapshot.error}.'),
                  );
                } else {
                  UserProfileData user = snapshot.data as UserProfileData;
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: double.infinity,
                        // If no background img is provided, make it transparent
                        decoration: BoxDecoration(
                            color: Colors.green,
                            image: user.profileBackground != null &&
                                    user.profileBackground!.isNotEmpty
                                ? DecorationImage(
                                    image:
                                        NetworkImage(user.profileBackground!),
                                    fit: BoxFit.cover)
                                : null),
                        child: Column(
                          children: [
                            ClipPath(
                              clipper: OtherPeopleProfileBezierClipper(),
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: user.avatarUrl != null &&
                                            user.avatarUrl!.isNotEmpty
                                        ? NetworkImage(user.avatarUrl!)
                                        : null,
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
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _loadingFollow
                                  ? null
                                  : () async {
                                      setState(() {
                                        _loadingFollow = true;
                                      });
                                      bool isNowFollowing =
                                          await user.toggleFollow();
                                      setState(() {
                                        _loadingFollow = false;
                                        user.isFollowing = isNowFollowing;
                                      });
                                    },
                              child: _loadingFollow
                                  ? CircularProgressIndicator()
                                  : Text(
                                      user.isFollowing ? 'Unfollow' : 'Follow'),
                            ),
                          ],
                        ),
                      ),
                      // Posts label
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
                          ],
                        ),
                      ),
                      if (user.posts != null)
                        for (var post in user.posts!)
                          Post(
                            postData: post,
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

class OtherPeopleProfileBezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
