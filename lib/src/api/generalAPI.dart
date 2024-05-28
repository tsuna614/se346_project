import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:se346_project/src/data/global_data.dart';
import 'package:se346_project/src/data/types.dart';

class GeneralAPI {
  static Dio dio = Dio();
  final _firebase = FirebaseAuth.instance;
  //Singleton
  static final GeneralAPI _instance = GeneralAPI._internal();
  List<UserProfileData> _users = [];
  factory GeneralAPI() {
    return _instance;
  }
  GeneralAPI._internal();
  //Todo remove later: this is used to load sample data from "users_database.json" for searchUser
  Future<void> loadSampleData() async {
    String jsonString =
        await rootBundle.loadString('assets/users_database.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    for (var user in jsonData) {
      List<PostData>? posts = convertPostsFromJson(user['posts']);
      UserProfileData userProfileData = UserProfileData(
        id: user['userId'],
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
  Future<List<UserProfileData>> searchUser(String username,
      //Todo: Implement search using api later
      {int limit = 10,
      int page = 1}) async {
    if (_users.isEmpty) {
      await loadSampleData();
    }
    //Search using name only and also limit the result using page and limit
    List<UserProfileData> result = _users
        .where(
            (user) => user.name.toLowerCase().contains(username.toLowerCase()))
        .skip((page - 1) * limit)
        .take(limit)
        .toList();

    return result;
  }

  Future<bool?> addPostToWall(
      String content, File? media, String? sharePostId) async {
    String? uid = _firebase.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    //Attach file to a form
    FormData formData = FormData.fromMap({
      'userId': uid,
      'content': content,
      'media': media != null
          ? await MultipartFile.fromFile(media.path,
              filename: media.path.split('/').last)
          : null,
      'sharePostId': sharePostId,
    });
    //Print all form data value for debugging
    formData.fields.forEach((element) {
      print('Field: ${element.key} - ${element.value}');
    });
    //Set header for form data
    Response response = await dio.post('$baseUrl/post/postToWall',
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        }));

    return response.statusCode == 200;
  }

  //Get total user count, suppl
  Future<int> getUserCount(String username) async {
    if (_users.isEmpty) {
      await loadSampleData();
    }
    return _users
        .where(
            (user) => user.name.toLowerCase().contains(username.toLowerCase()))
        .length;
  }

  Future<List<PostData>?> loadHomePosts() async {
    String jsonString = await rootBundle.loadString('assets/posts.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    List<PostData>? posts = convertPostsFromJson(jsonData);
    return posts ?? [];
  }

  Future<UserProfileData?> loadCurrentUserProfile() async {
    print('Loading current user profile');
    String? uid = _firebase.currentUser?.uid;

    if (uid == null) {
      return null;
    } else {
      // "/UserWallPosts/:userId",
      Response response = await dio.get('$baseUrl/post/UserWallPosts/$uid');
      if (response.statusCode == 200) {
        print('Response: ${response.data}');
        Map<String, dynamic> userData = response.data['user'];
        List<dynamic> postData = response.data['posts'];
        print('User data: $userData');
        print('Post data: $postData');
        userData['posts'] = postData;
        UserProfileData userProfileData = convertUserProfileFromJson(userData);
        return userProfileData;
      } else {
        String jsonString =
            await rootBundle.loadString('assets/user_profile.json');
        Map<String, dynamic> jsonData = jsonDecode(jsonString);
        UserProfileData userProfileData = convertUserProfileFromJson(jsonData);
        return userProfileData;
      }
    }
  }

  List<PostData>? convertPostsFromJson(List<dynamic> jsonData) {
    List<PostData> posts = [];
    if (jsonData.isEmpty) {
      return null;
    }
    for (var post in jsonData) {
      List<CommentData> comments = (post['comments'] as List).map((comment) {
        return CommentData(
          id: comment['_id'],
          postId: comment['postId'],
          commenterId: comment['commenterId'],
          commenterName: comment['commenterName'],
          commenterAvatarUrl: comment['commenterAvatarUrl'],
          content: comment['content'],
          mediaUrl: comment['mediaUrl'],
          createdAt: DateTime.parse(comment['createdAt']),
          updatedAt: DateTime.parse(comment['updatedAt']),
        );
      }).toList();
      List<String> likes = (post['likes'] as List).map((like) {
        return like as String;
      }).toList();
      List<String> shares = (post['shares'] as List).map((share) {
        return share as String;
      }).toList();
      PostData postData = PostData(
        id: post['_id'],
        posterId: post['posterId'],
        name: post['name'],
        likes: likes,
        shares: shares,
        content: post['content'],
        comments: comments,
        mediaUrl: post['mediaUrl'],
        sharePostId: post['sharePostId'],
        groupId: post['groupId'],
        posterAvatarUrl: post['posterAvatarUrl'],
        createdAt: DateTime.parse(post['createdAt']),
        updatedAt: DateTime.parse(post['updatedAt']),
      );
      posts.add(postData);
    }
    return posts;
  }

  UserProfileData convertUserProfileFromJson(Map<String, dynamic> jsonData) {
    List<PostData>? posts = convertPostsFromJson(jsonData['posts'] ?? []);

    UserProfileData userProfileData = UserProfileData(
      id: jsonData['userId'],
      name: jsonData['name'],
      email: jsonData['email'],
      phone: jsonData['phone'],
      avatarUrl: jsonData['avatarUrl'],
      bio: jsonData['bio'],
      posts: posts,
      profileBackground: jsonData['profileBackground'],
    );
    return userProfileData;
  }
}
