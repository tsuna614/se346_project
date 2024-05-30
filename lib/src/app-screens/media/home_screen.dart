import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/api/postAPI.dart';

import 'package:se346_project/src/widgets/post.dart';
import 'package:se346_project/src/data/types.dart';

class HomeScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  final String appName;

  HomeScreen({Key? key, required this.alternateDrawer, required this.appName})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late Future<List<PostData>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostAPI().loadHomePosts();
  }

  void refresh() {
    setState(() {
      _postsFuture = PostAPI().loadHomePosts();
    });
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
                onPressed: widget.alternateDrawer,
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
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: _postsFuture,
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
                    List<PostData> jsonData = snapshot.data as List<PostData>;
                    if (jsonData.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('No posts to show. Make some friends!'),
                        ),
                      );
                    } else
                      return Column(children: [
                        for (var post in jsonData)
                          Post(
                            postData: post,
                            refreshPreviousScreen: refresh,
                          ),
                      ]);
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
