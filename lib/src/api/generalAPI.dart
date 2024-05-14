import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:se346_project/src/app-screens/profile/profile_screen.dart';
import 'package:se346_project/src/widgets/post.dart';

class GeneralAPI {
  static const String BASE_URL = 'https://api.themoviedb.org/3';
  //Singleton
  static final GeneralAPI _instance = GeneralAPI._internal();
  List<UserProfileData> _users = [];
  factory GeneralAPI() {
    return _instance;
  }
  GeneralAPI._internal();
  //Todo remove later
  Future<void> loadSampleData() async {
    String jsonString =
        await rootBundle.loadString('assets/users_database.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    for (var user in jsonData) {
      List<PostData> posts = [];
      for (var post in user['posts']) {
        PostData postData = PostData(
          id: post['id'],
          name: user['name'],
          content: post['content'],
          comments: post['comments'],
          mediaUrl: post['mediaUrl'],
        );
        posts.add(postData);
      }
      UserProfileData userProfileData = UserProfileData(
        id: user['id'],
        name: user['name'],
        email: user['email'],
        phone: user['phone'],
        avatarUrl: user['avatarUrl'],
        bio: user['bio'],
        posts: posts,
        profileBackground: user['profileBackground'],
      );
      _users.add(userProfileData);
    }
  }

  //Todo: change to api later. For now it load from "users_database.json"
  Future<List<UserProfileData>> searchUser(String username) async {
    if (_users.isEmpty) {
      await loadSampleData();
    }
    //Search using name only
    List<UserProfileData> result = _users
        .where(
            (user) => user.name.toLowerCase().contains(username.toLowerCase()))
        .toList();
    return result;
  }
}
