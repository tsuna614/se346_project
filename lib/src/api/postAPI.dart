import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/api/generalConverter.dart';
import 'package:se346_project/src/data/global_data.dart';
import 'package:se346_project/src/data/types.dart';

class PostAPI {
  static Dio dio = Dio();
  final _firebase = FirebaseAuth.instance;
  //Singleton
  static final PostAPI _instance = PostAPI._internal();
  factory PostAPI() {
    return _instance;
  }
  PostAPI._internal();
  //Will return current like status
  Future<bool> toggleLikePost(String postId) async {
    if (postId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.put('$baseUrl/post/$postId/toggleLike',
          data: {'userId': _firebase.currentUser!.uid});
      Map<String, dynamic> data = res.data;
      return data['isLiked'];
    } catch (e) {
      print("Error liking post: $e");
      return false;
    }
  }

  Future<bool> commentPost(String postId, String content, File? media) async {
    if (postId.isEmpty || content.isEmpty) {
      return false;
    }
    try {
      FormData formData = FormData.fromMap({
        'userId': _firebase.currentUser!.uid,
        'content': content,
        'media': media != null
            ? await MultipartFile.fromFile(media.path,
                filename: media.path.split('/').last)
            : null,
      });
      final res =
          await dio.post('$baseUrl/post/$postId/comment', data: formData);
      return res.statusCode == 200;
    } catch (e) {
      print("Error commenting post: $e");
      return false;
    }
  }

  Future<List<PostData>> loadHomePosts() async {
    try {
      //Get /post/cleanDatatbase to clean up database

      final res = await dio.get('$baseUrl/post/home',
          queryParameters: {'userId': _firebase.currentUser!.uid});
      List<dynamic> jsonData = res.data;
      List<PostData> posts = [];
      for (var post in jsonData) {
        posts.add(await PostData.fromJson(post));
      }

      // return posts;
      return posts;
    } catch (e) {
      print("Error loading home posts: $e");
      return [];
    }
  }
}
