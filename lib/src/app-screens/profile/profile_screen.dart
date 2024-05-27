import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/widgets/post.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/data/types.dart';

class ProfileScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const ProfileScreen({Key? key, required this.alternateDrawer})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              future: GeneralAPI().loadCurrentUserProfile(),
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
                        height: 200,
                        width: double.infinity,
                        //Add background profile image
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: user.profileBackground!)
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
                                        image: user.avatarUrl ?? '')
                                    .image,
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

                      if (user.posts != null)
                        for (var post in user.posts!)
                          Post(
                            postData: post,
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
