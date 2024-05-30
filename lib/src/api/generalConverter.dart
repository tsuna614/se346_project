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
      PostData postData = PostData.fromJson(post);

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
      profileBackground: jsonData['profileBackground'] ?? '',
      followers: followers,
      isFollowing: jsonData['isFollowing'] ?? false,
    );

    return userProfileData;
  }
}
