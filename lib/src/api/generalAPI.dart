import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:se346_project/src/data/global_data.dart';
import 'package:se346_project/src/data/types.dart';

import 'package:se346_project/src/api/generalConverter.dart';

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
      List<PostData>? posts =
          GeneralConverter.convertPostsFromJson(user['posts']);
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

  Future<List<UserProfileData>> searchUser(
    String name,
    //Todo: Implement search using api later
    {
    int limit = 10,
    int page = 1,
  }) async {
    final res = await dio.get('$baseUrl/user/', queryParameters: {
      'name': name,
      'userId': _firebase.currentUser?.uid,
      'limit': limit,
      'page': page,
    });

    List<dynamic> jsonData = res.data;
    List<UserProfileData> users = jsonData.map((user) {
      return GeneralConverter.convertUserProfileFromJson(user);
    }).toList();
    return users;
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

  //Create group
  Future<bool?> createGroup(
      String name, String description, File? media) async {
    String? uid = _firebase.currentUser?.uid;

    if (uid == null) {
      return null;
    }
    if (description.isEmpty) {
      description = '...';
    }
    //Send name, description, and uid in body and banner (media field) in multipart
    FormData formData = FormData.fromMap({
      'name': name,
      'description': description,
      'userId': uid,
      'media': media != null
          ? await MultipartFile.fromFile(media.path,
              filename: media.path.split('/').last)
          : null,
    });

    Response response = await dio.post('$baseUrl/group/',
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

    List<PostData>? posts = GeneralConverter.convertPostsFromJson(jsonData);
    return posts ?? [];
  }

  Future<UserProfileData?> loadProfile(String uid) async {
    if (uid == null) {
      return null;
    } else {
      // "/UserWallPosts/:userId",
      Response response = await dio.get('$baseUrl/post/UserWallPosts/$uid');
      if (response.statusCode == 200) {
        print(response.data);
        Map<String, dynamic> userData = response.data['user'];
        List<dynamic> postData = response.data['posts'];

        userData['posts'] = postData;
        UserProfileData userProfileData =
            GeneralConverter.convertUserProfileFromJson(userData);
        return userProfileData;
      } else {
        return null;
      }
    }
  }

  Future<UserProfileData?> loadCurrentUserProfile() async {
    String? uid = _firebase.currentUser?.uid;

    if (uid == null) {
      return null;
    } else {
      // "/UserWallPosts/:userId",
      Response response = await dio.get('$baseUrl/post/UserWallPosts/$uid');
      if (response.statusCode == 200) {
        print(response.data);
        Map<String, dynamic> userData = response.data['user'];
        List<dynamic> postData = response.data['posts'];

        userData['posts'] = postData;
        UserProfileData userProfileData =
            GeneralConverter.convertUserProfileFromJson(userData);
        return userProfileData;
      } else {
        return null;
      }
    }
  }

  Future<List<GroupData>?> searchGroup(String groupName) async {
    //Attach userid and group name
    Response response = await dio.get('$baseUrl/group/', queryParameters: {
      'name': groupName,
      'userId': _firebase.currentUser?.uid
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;
      List<GroupData> groups = jsonData.map((group) {
        return GeneralConverter.convertGroupFromJson(group);
      }).toList();

      return groups;
    } else {
      return null;
    }
  }
}
