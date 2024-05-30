import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/api/groupAPI.dart';
import 'package:se346_project/src/api/postAPI.dart';

class UserProfileData {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final List<PostData>? posts;
  final String? profileBackground;
  List<String>? followers;
  bool isFollowing;
  //Created at / updated at
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isCurrentUser;
  UserProfileData(
      {required this.id,
      required this.name,
      required this.email,
      this.phone,
      this.avatarUrl,
      this.bio,
      this.posts,
      this.profileBackground = "",
      this.followers,
      this.createdAt,
      this.updatedAt,
      this.isFollowing = false,
      this.isCurrentUser = false});

  Future<bool> toggleFollow() async {
    bool following = await GeneralAPI().toggleFollow(id);
    isFollowing = following;

    return following;
  }
}

//Same as user profile data, all user wall posts are public and can be viewed by anyone
//Only check if they are following the user to view their profile
// Returned for search results

//Returned on home
//Can query group name if post is in a group
//Can query user profile for related user info

class PostData {
  final String id;
  final String posterId;
  final String name; // poster name
  final String content;
  List<CommentData> comments;
  // List of user ids who liked the post
  final List<String>? likes;
  //List of user ids who shared the post
  final List<String>? shares;
  final String? posterAvatarUrl;
  final String? mediaUrl;
  final String? groupId;
  final String? sharePostId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? userIsPoster;
  bool? userLiked;
  final bool isEdited;

  PostData({
    required this.id,
    required this.posterId,
    required this.name,
    required this.content,
    this.comments = const [],
    this.posterAvatarUrl,
    this.mediaUrl,
    this.groupId,
    this.sharePostId,
    this.likes,
    this.shares,
    required this.createdAt,
    required this.updatedAt,
    this.isEdited = false,
    this.userIsPoster,
    this.userLiked,
  });
  Future<PostData?> fetchSharedPost() async {
    // Implement the logic to fetch the shared post data using sharePostId.
    // This is a placeholder function and should be replaced with actual data fetching logic.
    return Future.delayed(Duration(seconds: 2), () {
      // Simulating a network call
      return PostData(
        id: 'shared_post_id',
        posterId: 'shared_poster_id',
        name: 'Shared Poster Name',
        content: 'This is the content of the shared post.',
        comments: [],
        likes: [],
        shares: [],
        posterAvatarUrl: null,
        mediaUrl: null,
        groupId: null,
        sharePostId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userIsPoster: false,
        userLiked: false,
        isEdited: false,
      );
    });
  }

  Future<void> likePost() async {
    bool isLiked = await PostAPI().toggleLikePost(id);
    userLiked = isLiked;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (isLiked) {
      likes?.add(currentUserId);
    } else {
      likes?.remove(currentUserId);
    }

    print('Post liked: $isLiked');
  }

  Future<bool> commentPost(String content, File? media) async {
    try {
      bool result = await PostAPI().commentPost(id, content, media);
      return result;
    } catch (e, stackTrace) {
      print('Error commenting post: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> removeComment(String commentId) async {
    try {
      bool result = await PostAPI().removeComment(id, commentId);
      return result;
    } catch (e, stackTrace) {
      print('Error removing comment: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<List<CommentData>> loadComments() async {
    comments = await PostAPI().loadComments(id);
    print('Comments loaded: ${comments.length}');
    return comments;
  }

  Future<void> unlikePost() async {
    // Implementation to unlike the post
  }

  Future<void> deletePost() async {
    // Implementation to delete the post
  }

  Future<void> reportPost() async {
    // Implementation to report the post
  }

  Future<void> sharePost() async {
    // Implementation to share the post
  }

  Future<GroupData> getGroup() async {
    // Implementation to get group details
    return GroupData(id: '', name: '', description: '');
  }

  Future<String?> getGroupName() async {
    // Implementation to get group name
    if (groupId != null) {
      return GroupAPI().getGroupName(groupId!);
    }
    return null;
  }

  Future<UserProfileData> getPosterProfile() async {
    // Implementation to get poster profile
    return UserProfileData(
      id: posterId,
      name: name,
      email: '',
    );
  }

  static PostData fromJson(Map<String, dynamic> json) {
    try {
      List<CommentData> commentData = (json['comments'] as List).map((comment) {
        return CommentData.fromJson(comment);
      }).toList();

      List<String> likes = (json['likes'] as List).map((like) {
        return like as String;
      }).toList();
      List<String> shares = (json['shares'] as List).map((share) {
        return share as String;
      }).toList();

      PostData postData = PostData(
        id: json['_id'],
        posterId: json['posterId'],
        name: json['name'],
        likes: likes,
        shares: shares,
        content: json['content'],
        comments: commentData,
        mediaUrl: json['mediaUrl'],
        sharePostId: json['sharePostId'],
        groupId: json['groupId'],
        posterAvatarUrl: json['posterAvatarUrl'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        userLiked: json['userLiked'] ?? false,
        userIsPoster: json['userIsPoster'] ?? json['userIsPoster'] == 'true'
            ? true
            : false,
      );

      return postData;
    } catch (e, stackTrace) {
      print('Error during parsing JSON: $e');
      print('Stack trace: $stackTrace');
      // Add more specific error handling if needed
      throw e; // Rethrow the exception to propagate it upwards
    }
  }
}

class CommentData {
  final String id;
  final String postId;
  final String commenterId;
  final String commenterName;
  final String? commenterAvatarUrl;
  final String content;
  final String? mediaUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isCommenter; // To track if the current user is the commenter
  CommentData({
    required this.id,
    required this.postId,
    required this.commenterId,
    required this.commenterName,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.commenterAvatarUrl,
    this.mediaUrl,
    this.isCommenter = false,
  });

  static CommentData fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['_id'],
      postId: json['postId'],
      commenterId: json['commenterId'],
      commenterName: json['commenterName'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      commenterAvatarUrl: json['commenterAvatarUrl'],
      isCommenter: json['isCommenter'] ?? false,
    );
  }
}

class GroupData {
  final String id;
  final String name;
  final String description;
  final String? bannerImgUrl;
  final List<String>? postIds; // Changed to List of IDs for simplicity
  final List<GroupMemberData>? members;
  final List<GroupMemberData>? admins;
  final List<String>? followers; // Assuming followers are just user IDs
  bool isMember; // To track if the current user is a member
  bool isAdmin;

  GroupData({
    required this.id,
    required this.name,
    required this.description,
    this.bannerImgUrl,
    this.postIds,
    this.members,
    this.admins,
    this.followers,
    this.isMember = false,
    this.isAdmin = false,
  });

  // Method to join the group
  Future<void> joinGroup() async {
    bool result = await GroupAPI().joinGroup(id);
    if (result) {
      isMember = true;
    }
  }

  // Method to leave the group
  Future<void> leaveGroup() async {
    bool result = await GroupAPI().leaveGroup(id);
    if (result) {
      isMember = false;
    }
  }

  // Method to get group posts
  Future<List<PostData>> getGroupPosts() async {
    //Todo: implement get group posts
    List<PostData> posts = await GroupAPI().getGroupPosts(id);

    return posts;
  }

  // Method to get member list
  Future<List<GroupMemberData>> getMembers() async {
    // Implementation to retrieve member list
    return members ?? [];
  }

  // Method to get admin list
  Future<List<GroupMemberData>> getAdmins() async {
    // Implementation to retrieve admin list
    return admins ?? [];
  }

  // Method to check if a user is following the group
  bool isFollowing(String userId) {
    return followers?.contains(userId) ?? false;
  }
}

// Only have name, id, and avatar url for quick access
class GroupMemberData {
  final String id;
  final String name;
  final String? avatarUrl;

  GroupMemberData({required this.id, required this.name, this.avatarUrl});
}
