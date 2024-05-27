class UserProfileData {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final List<PostData>? posts;
  final String? profileBackground;
  final List<String>? followers;
  //Created at / updated at
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
      this.updatedAt});
}

//Same as user profile data, all user wall posts are public and can be viewed by anyone
//Only check if they are following the user to view their profile
// Returned for search results
class OtherPeopleProfileData {
  final String id;
  final String name;
  final String? bio;
  final String? phone;
  final String? email;
  final List<PostData>? posts;
  final String? avatarUrl;
  final String? profileBackground;
  final String? followers;

  final bool? isFollowing;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  OtherPeopleProfileData({
    required this.id,
    required this.name,
    this.bio,
    this.phone,
    this.email,
    this.posts,
    this.avatarUrl,
    this.profileBackground,
    this.isFollowing,
    this.followers,
    this.createdAt,
    this.updatedAt,
  });
}

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
  });

  Future<void> addComment(CommentData comment) async {
    // Implementation to add a comment
  }

  Future<void> deleteComment(String commentId) async {
    // Implementation to delete a comment
  }

  Future<void> likePost() async {
    // Implementation to like the post
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

  Future<OtherPeopleProfileData> getPosterProfile() async {
    // Implementation to get poster profile
    return OtherPeopleProfileData(
        id: '', name: '', createdAt: DateTime.now(), updatedAt: DateTime.now());
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
  });
}

class GroupData {
  final String id;
  final String name;
  final String description;
  final String? posterImgUrl;
  final List<PostData>? posts;
  final List<String>? members;
  final List<String>? admins;
  final List<String>? followers;
  GroupData({
    required this.id,
    required this.name,
    required this.description,
    this.posterImgUrl,
    this.posts,
    this.members,
    this.admins,
    this.followers,
  });

  Future<void> joinGroup() async {}
  Future<void> leaveGroup() async {}
}
