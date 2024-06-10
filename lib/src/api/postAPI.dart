import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<bool> deletePost(String postId) async {
    if (postId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.delete('$baseUrl/post/$postId',
          data: {'userId': _firebase.currentUser!.uid});
      return res.statusCode == 200;
    } catch (e) {
      print("Error removing post: $e");
      return false;
    }
  }

  Future<bool> sharePost(String postId) async {
    if (postId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.post('$baseUrl/post/sharePost',
          data: {'userId': _firebase.currentUser!.uid, 'postId': postId});
      return res.statusCode == 200;
    } catch (e) {
      print("Error sharing post: $e");
      return false;
    }
  }

  Future<bool> reportPost(String postId, String reason) async {
    if (postId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.post('$baseUrl/post/$postId/report',
          data: {'userId': _firebase.currentUser!.uid, 'reason': reason});
      return res.statusCode == 200;
    } catch (e) {
      print("Error reporting post: $e");
      return false;
    }
  }

  Future<PostData?> getPost(String postId) async {
    if (postId.isEmpty) {
      return null;
    }
    try {
      final res = await dio.get('$baseUrl/post/$postId',
          queryParameters: {'userId': _firebase.currentUser!.uid});
      return PostData.fromJson(res.data);
    } catch (e) {
      print("Error getting post: $e");
      throw e;
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
          await dio.post('$baseUrl/post/$postId/comments', data: formData);
      return res.statusCode == 200;
    } catch (e) {
      print("Error commenting post: $e");
      return false;
    }
  }

  Future<bool> removeComment(String postId, String commentId) async {
    if (postId.isEmpty || commentId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.delete('$baseUrl/post/$postId/comments/$commentId',
          data: {'userId': _firebase.currentUser!.uid});
      return res.statusCode == 200;
    } catch (e) {
      print("Error removing comment: $e");
      return false;
    }
  }

  Future<List<CommentData>> loadComments(String postId) async {
    if (postId.isEmpty) {
      return [];
    }
    try {
      final res =
          await dio.get('$baseUrl/post/$postId/comments', queryParameters: {
        'userId': _firebase.currentUser!.uid,
      });
      List<dynamic> jsonData = res.data;

      List<CommentData> comments = [];
      for (var comment in jsonData) {
        comments.add(CommentData.fromJson(comment));
      }
      return comments;
    } catch (e, stackTrace) {
      print("Error loading comments: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  Future<List<PostData>> loadHomePosts() async {
    try {
      //Get /post/cleanDatatbase to clean up database

      print('$baseUrl/post/home');
      print(_firebase.currentUser!.uid);
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
