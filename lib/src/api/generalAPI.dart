import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:se346_project/src/data/global_data.dart';
import 'package:se346_project/src/data/types.dart';

import 'package:se346_project/src/api/generalConverter.dart';

class GeneralAPI {
  static Dio dio = Dio();
  final _firebase = FirebaseAuth.instance;
  //Singleton
  static final GeneralAPI _instance = GeneralAPI._internal();
  // List<UserProfileData> _users = [];
  factory GeneralAPI() {
    return _instance;
  }
  GeneralAPI._internal();

  Future<List<UserProfileData>> getFriends() async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return [];
    }
    final res = await dio.get('$baseUrl/user/$uid/friends');
    List<dynamic> jsonData = res.data;
    List<UserProfileData> users = jsonData.map((user) {
      return GeneralConverter.convertUserProfileFromJson(user);
    }).toList();
    return users;
  }

  Future<List<UserProfileData>> getFollowing() async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return [];
    }
    print('$baseUrl/user/$uid/following');
    final res = await dio.get('$baseUrl/user/$uid/following');
    List<dynamic> jsonData = res.data;
    List<UserProfileData> users = jsonData.map((user) {
      return GeneralConverter.convertUserProfileFromJson(user);
    }).toList();
    return users;
  }

  Future<UserProfileData?> changeAvatar(File avatar) async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return null;
    }
    FormData formData = FormData.fromMap({
      'userId': uid,
      'media': await MultipartFile.fromFile(avatar.path,
          filename: avatar.path.split('/').last),
    });
    Response response = await dio.put('$baseUrl/user/changeAvatar',
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> userData = response.data;
      return GeneralConverter.convertUserProfileFromJson(userData);
    } else {
      return null;
    }
  }

  Future<UserProfileData?> changeProfileBackground(
      File profileBackground) async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return null;
    }
    FormData formData = FormData.fromMap({
      'userId': uid,
      'media': await MultipartFile.fromFile(profileBackground.path,
          filename: profileBackground.path.split('/').last),
    });
    Response response = await dio.put('$baseUrl/user/changeProfileBackground',
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> userData = response.data;
      return GeneralConverter.convertUserProfileFromJson(userData);
    } else {
      return null;
    }
  }

  Future<UserProfileData?> changeBio(String bio) async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return null;
    }
    final res = await dio
        .put('$baseUrl/user/changeBio', data: {'userId': uid, 'bio': bio});
    if (res.statusCode == 200) {
      Map<String, dynamic> userData = res.data;
      return GeneralConverter.convertUserProfileFromJson(userData);
    } else {
      return null;
    }
  }

  Future<UserProfileData?> changeName(String name) async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return null;
    }
    final res = await dio
        .put('$baseUrl/user/changeName', data: {'userId': uid, 'name': name});
    if (res.statusCode == 200) {
      Map<String, dynamic> userData = res.data;
      return GeneralConverter.convertUserProfileFromJson(userData);
    } else {
      return null;
    }
  }

  Future<List<GroupData>> getGroupsUserIsIn() async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return [];
    }
    final res = await dio.get('$baseUrl/user/$uid/groups');
    List<dynamic> jsonData = res.data;
    List<GroupData> groups = jsonData.map((group) {
      return GeneralConverter.convertGroupFromJson(group);
    }).toList();
    return groups;
  }

  //Is used along side with get user count
  Future<List<UserProfileData>> searchUser(
    String name, {
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

  //Get total user count, supply username to search
  Future<int> getUserCount(String username) async {
    //Query exactly the same as searchUser. Return the header 'X-Total-Count' from response
    final res = await dio.get('$baseUrl/user/', queryParameters: {
      'name': username,
      'userId': _firebase.currentUser?.uid,
    });
    return int.parse(res.headers['X-Total-Count']?[0] ?? '0');
  }

  Future<UserProfileData?> loadOtherProfile(String otherUserId) async {
    String uid = _firebase.currentUser?.uid ?? '';
    if (otherUserId.isEmpty || uid.isEmpty) {
      return null;
    } else {
      // "/UserWallPosts/:userId",
      Response response = await dio.get('$baseUrl/post/UserWallPosts/$uid',
          queryParameters: {'otherUserId': otherUserId});
      if (response.statusCode == 200) {
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

  //The result is a boolean, if the current user is now following the target user
  Future<bool> toggleFollow(String userId) async {
    if (userId.isEmpty) {
      return false;
    }
    try {
      final res = await dio.put('$baseUrl/user/toggleFollow',
          data: {'userId': _firebase.currentUser!.uid, 'followId': userId});
      Map<String, dynamic> data = res.data;

      return data['isFollowing'];
    } catch (e) {
      print("Error following user: $e");
      return false;
    }
  }

  Future<bool> checkForExistingRequest(String friendId) async {
    String userId = _firebase.currentUser!.uid;
    bool isExisting = false;
    await FirebaseFirestore.instance
        .collection('notifications')
        .where('sender', isEqualTo: userId)
        .where('receiver', isEqualTo: friendId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isExisting = true;
      }
    });
    return isExisting;
  }

  Future<bool> isUserAlreadyFriend(String userId) async {
    String currentUserId = _firebase.currentUser!.uid;
    bool isExisting = false;
    try {
      final response = await dio.get('$baseUrl/user/$currentUserId');
      if (response.data[0]["friends"].contains(userId)) {
        isExisting = true;
      }
      return isExisting;
    } catch (e) {
      print("Error: $e");
      return isExisting;
    }
  }

  void cancelFriendRequest(String friendId) {
    String userId = _firebase.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('notifications')
        .where('sender', isEqualTo: userId)
        .where('receiver', isEqualTo: friendId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('notifications')
            .doc(element.id)
            .delete();
      });
    });
  }

  void sendFriendRequest(String friendId) {
    String userId = _firebase.currentUser!.uid;

    FirebaseFirestore.instance.collection('notifications').add({
      'sender': userId,
      'receiver': friendId,
      'timeCreated': DateTime.now(),
    });
  }

  void unFriend(String friendId) async {
    String currentUserId = _firebase.currentUser!.uid;

    Dio dio = Dio();
    await dio.put('$baseUrl/user/removeFriend/$friendId/$currentUserId');
  }

  void removeNotification(String notificationId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Future<void> addFriend(String senderId, String receiverId) async {
    final dio = Dio();
    await dio.put('$baseUrl/user/addFriend/$senderId/$receiverId');
  }
}
