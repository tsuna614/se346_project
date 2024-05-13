import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/widgets/top_navigator.dart';
import 'package:se346_project/src/widgets/post.dart';

class HomeScreen extends StatelessWidget {
  final void Function() alternateDrawer;
  final String appName;

  HomeScreen({Key? key, required this.alternateDrawer, required this.appName})
      : super(key: key);

  final auth = FirebaseAuth.instance;

  Future<List<dynamic>> _loadPosts() async {
    String jsonString = await rootBundle.loadString('assets/posts.json');

    List<dynamic> jsonData = jsonDecode(jsonString);

    List<Map<String, dynamic>> posts =
        jsonData.map((item) => item as Map<String, dynamic>).toList();

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.green),
                onPressed: alternateDrawer,
              ),
              //Use the variable appName to display the app name
              title: const Text('Notfacebook',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              floating: true,
              expandedHeight: 50.0,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TopNavigatorDelegate(),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: _loadPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    List<dynamic> jsonData = snapshot.data as List<dynamic>;
                    return Column(
                      children: [
                        for (var post in jsonData)
                          Post(
                            name: post['name'],
                            content: post['content'],
                            comments: post['comments'],
                            avatarUrl: post['avatarUrl'],
                            //Conditionally check if media property exist
                            mediaUrl: post.containsKey('media')
                                ? post['media']
                                : null,
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavigatorDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TopNavigator();
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant _TopNavigatorDelegate oldDelegate) {
    return false;
  }
}
