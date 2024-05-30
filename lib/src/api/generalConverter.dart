import 'package:se346_project/src/data/types.dart';

class GeneralConverter {
  static GroupData convertGroupFromJson(Map<String, dynamic> jsonData) {
    List<GroupMemberData> members = (jsonData['members'] as List).map((member) {
      return GroupMemberData(
        id: member['id'],
        name: member['name'],
        avatarUrl: member['avatarUrl'],
      );
    }).toList();
    List<GroupMemberData> admins = (jsonData['admins'] as List).map((admin) {
      return GroupMemberData(
        id: admin['id'],
        name: admin['name'],
        avatarUrl: admin['avatarUrl'],
      );
    }).toList();
    GroupData groupData = GroupData(
      id: jsonData['_id'],
      name: jsonData['name'],
      description: jsonData['description'],
      bannerImgUrl: jsonData['bannerImgUrl'],
      members: members,
      admins: admins,
      isMember: jsonData['isMember'] ?? false,
    );
    return groupData;
  }

  static GroupMemberData convertGroupMemberFromJson(
      Map<String, dynamic> jsonData) {
    GroupMemberData groupMemberData = GroupMemberData(
      id: jsonData['id'],
      name: jsonData['name'],
      avatarUrl: jsonData['avatarUrl'],
    );
    return groupMemberData;
  }

  static List<PostData>? convertPostsFromJson(List<dynamic> jsonData) {
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
        userLiked: post['userLiked'] ?? false,
        userIsPoster: post['userIsPoster'] ?? false,
      );
      posts.add(postData);
    }
    return posts;
  }

  static UserProfileData convertUserProfileFromJson(
      Map<String, dynamic> jsonData) {
    List<PostData>? posts = convertPostsFromJson(jsonData['posts'] ?? []);
    List<String> followers = jsonData['followers'] != null
        ? (jsonData['followers'] as List).map((follower) {
            return follower as String;
          }).toList()
        : [];
    print("Followers: $followers");
    UserProfileData userProfileData = UserProfileData(
      id: jsonData['userId'],
      name: jsonData['name'],
      email: jsonData['email'],
      phone: jsonData['phone'],
      avatarUrl: jsonData['avatarUrl'],
      bio: jsonData['bio'],
      posts: posts,
      profileBackground: jsonData['profileBackground'],
      followers: followers,
      isFollowing: jsonData['isFollowing'] ?? false,
    );

    return userProfileData;
  }
}
