import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:se346_project/src/data/global_data.dart' as globals;

class UserProvider with ChangeNotifier {
  String userId = '';
  String userName = '';
  String userEmail = '';
  String avatarUrl = '';
  List<String> bookmarksTitle = [];

  Future<void> fetchUserData(String userId) async {
    // Replace with your actual API call
    final dio = Dio();

    Response response =
        await dio.get('${globals.baseUrl}/user/getUserById/$userId');

    if (response.statusCode == 200) {
      clearUser();
      setUser(response: response);
    } else {
      print('Failed to load user data');
    }
  }

  void clearUser() {
    userId = '';
    userName = '';
    userEmail = '';
    avatarUrl = '';
    bookmarksTitle.clear();
    notifyListeners();
  }

  void setUser({required Response response}) {
    userId = response.data[0]['userId'];
    userName = response.data[0]['name'];
    userEmail = response.data[0]['email'];
    avatarUrl = response.data[0]['avatarUrl'];
    for (int i = 0; i < response.data[0]['bookmarkedPosts'].length; i++) {
      bookmarksTitle.add(response.data[0]['bookmarkedPosts'][i]);
    }
    notifyListeners();
  }

  void addBookmark({required String title}) {
    bookmarksTitle.add(title);
    updateUser();
    notifyListeners();
  }

  void removeBookmark({required String title}) {
    bookmarksTitle.remove(title);
    updateUser();
    notifyListeners();
  }

  void updateUser() async {
    final dio = Dio();

    await dio.put('${globals.baseUrl}/user/editUserById/$userId', data: {
      'name': userName,
      'email': userEmail,
      'avatarUrl': avatarUrl,
      'bookmarkedPosts': bookmarksTitle,
    }).then((value) {
      print('User updated');
    }).catchError((error) {
      print('Failed to update user');
    });
  }
}
