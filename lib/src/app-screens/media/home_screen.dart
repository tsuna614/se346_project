import 'dart:convert';
import 'dart:io'; // Add this import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/widgets/bottom_navigation_bar.dart';
import 'package:se346_project/src/widgets/post.dart';

class HomeScreen extends StatelessWidget {
  final void Function() alternateDrawer;
  HomeScreen({super.key, required this.alternateDrawer});

  final auth = FirebaseAuth.instance;
  //Todo: Sample implementation using json file. Replace it with api fetching later.
  Future<List<dynamic>> _loadPosts() async {
    // Read the JSON file from assets
    String jsonString = await rootBundle.loadString('assets/posts.json');

    List<dynamic> jsonData = jsonDecode(jsonString);

    // Explicitly cast each item in the list to Map<String, dynamic>
    List<Map<String, dynamic>> posts =
        jsonData.map((item) => item as Map<String, dynamic>).toList();

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomNavigator(),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                alternateDrawer();
              },
              icon: Icon(Icons.menu)),
          title: const Text(
            'Homepage',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: FutureBuilder(
          future: _loadPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while loading data
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              List<dynamic> jsonData = snapshot.data!;
              return Column(
                children: [
                  for (var post in jsonData)
                    Post(
                      name: post['name'],
                      content: post['content'],
                      comments: post['comments'],
                      avatarUrl: post['avatarUrl'],
                    ),
                ],
              );
            }
          },
        ))));
  }
}
