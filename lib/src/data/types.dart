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
      this.profileBackground,
      this.followers,
      this.createdAt,
      this.updatedAt,
      this.isFollowing = false,
      this.isCurrentUser = false});

  Future<bool> toggleFollow() async {
    bool following = await GeneralAPI().toggleFollow(id);
    if (following) {
      isFollowing = !isFollowing;
    }

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
  final List<CommentData> comments;
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

  static Future<PostData> fromJson(Map<String, dynamic> json) async {
    List<CommentData> comments = [];
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
      comments: comments,
      mediaUrl: json['mediaUrl'],
      sharePostId: json['sharePostId'],
      groupId: json['groupId'],
      posterAvatarUrl: json['posterAvatarUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userLiked: json['userLiked'] ?? false,
      userIsPoster: json['userIsPoster'] ?? false,
    );
    return postData;
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

  static fromJson(Map<String, dynamic> json) {
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
