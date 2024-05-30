import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/data/global_data.dart';
import 'package:se346_project/src/api/generalConverter.dart';

class GroupAPI {
  static Dio dio = Dio();
  final _firebase = FirebaseAuth.instance;
  //Singleton
  static final GroupAPI _instance = GroupAPI._internal();
  List<GroupData> _groups = [];
  factory GroupAPI() {
    return _instance;
  }
  GroupAPI._internal();

  Future<bool> joinGroup(String groupId) async {
    if (groupId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.post('$baseUrl/group/$groupId/members',
          data: {'userId': _firebase.currentUser!.uid});
      return res.statusCode == 200;
    } catch (e) {
      print("Error joining group: $e");
      return false;
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

  Future<bool> leaveGroup(String groupId) async {
    if (groupId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.delete('$baseUrl/group/$groupId/members/',
          data: {'userId': _firebase.currentUser!.uid});

      return res.statusCode == 200;
    } catch (e) {
      print("Error leaving group: $e");
      return false;
    }
  }

  Future<List<PostData>> getGroupPosts(String groupId) async {
    if (groupId.isEmpty) {
      return [];
    }
    try {
      final res =
          await dio.get('$baseUrl/group/$groupId/posts', queryParameters: {
        'userId': _firebase.currentUser!.uid,
      });
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['posts'];

        return GeneralConverter.convertPostsFromJson(data)!;
      }
      return [];
    } catch (e) {
      print("Error getting group posts: $e");
      return [];
    }
  }

  Future<String?> getGroupName(String groupId) async {
    if (groupId.isEmpty) {
      return null;
    }
    try {
      final res = await dio.get('$baseUrl/group/$groupId', queryParameters: {
        'userId': _firebase.currentUser!.uid,
      });
      if (res.statusCode == 200) {
        Map<String, dynamic> data = res.data;
        return data['name'];
      }
      return null;
    } catch (e) {
      print("Error getting group name: $e");
      return null;
    }
  }

  Future<bool> postToGroup(String groupId, String content, File? image) async {
    if (groupId.isEmpty || content.isEmpty) {
      return false;
    }
    try {
      FormData data = FormData.fromMap({
        'userId': _firebase.currentUser!.uid,
        'content': content,
        'media':
            image != null ? await MultipartFile.fromFile(image.path) : null,
      });
      final res = await dio.post('$baseUrl/group/$groupId/posts', data: data);
      return res.statusCode == 200;
    } catch (e) {
      print("Error posting to group: $e");
      return false;
    }
  }
}
