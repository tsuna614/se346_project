import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/api/generalAPI.dart';

import 'package:se346_project/src/widgets/post.dart';
import 'package:se346_project/src/data/types.dart';

class HomeScreen extends StatelessWidget {
  final void Function() alternateDrawer;
  final String appName;

  HomeScreen({Key? key, required this.alternateDrawer, required this.appName})
      : super(key: key);

  final auth = FirebaseAuth.instance;

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
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: GeneralAPI().loadHomePosts(),
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
                    return Column(children: [
                      for (var post in jsonData)
                        Post(
                          postData: post,
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
