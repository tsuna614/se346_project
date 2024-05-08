import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:se346_project/src/widgets/bottom_navigation_bar.dart';
import 'package:se346_project/src/widgets/post.dart';
import 'package:se346_project/src/data/sample_posts_data.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: AppBar(
        //Use assets/images/logo.png then "Home Screen"
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 30,
            ),
            const SizedBox(width: 8.0),
            const Text('Homepage',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: samplePosts
              .map((post) => Post(
                    name: post['name']!,
                    content: post['content']!,
                    onLike: () {},
                    onComment: () {},
                    onShare: () {},
                  ))
              .toList(),
        ),
      )),
    );
  }
}
