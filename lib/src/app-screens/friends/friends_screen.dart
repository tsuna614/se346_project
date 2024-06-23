import 'package:flutter/material.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/groupPage.dart';
import 'package:se346_project/src/app-screens/social/social_screen.dart';

class FriendsScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const FriendsScreen({Key? key, required this.alternateDrawer})
      : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<UserProfileData>> _friendsFuture;
  late Future<List<UserProfileData>> _followingsFuture;
  late Future<List<GroupData>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _friendsFuture = _fetchFriends();
    _followingsFuture = _fetchFollowings();
    _groupsFuture = _fetchGroups();
  }

  Future<List<UserProfileData>> _fetchFriends() async {
    return await GeneralAPI().getFriends();
  }

  Future<List<UserProfileData>> _fetchFollowings() async {
    return await GeneralAPI().getFollowing();
  }

  Future<List<GroupData>> _fetchGroups() async {
    return await GeneralAPI().getGroupsUserIsIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.green),
          onPressed: widget.alternateDrawer,
        ),
        title: Text(
          'Your connections',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Followings'),
            Tab(text: 'Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildFollowingsTab(),
          _buildGroupsTab(),
        ],
      ),
    );
  }

  Widget _buildFriendsTab() {
    return FutureBuilder<List<UserProfileData>>(
      future: _friendsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final followings = snapshot.data ?? [];
          return ListView.builder(
            itemCount: followings.length,
            itemBuilder: (context, index) {
              final following = followings[index];
              return SocialFriendItem(profileData: following);
            },
          );
        }
      },
    );
  }

  Widget _buildFollowingsTab() {
    return FutureBuilder<List<UserProfileData>>(
      future: _followingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final followings = snapshot.data ?? [];
          return ListView.builder(
            itemCount: followings.length,
            itemBuilder: (context, index) {
              final following = followings[index];
              return SocialFriendItem(profileData: following);
            },
          );
        }
      },
    );
  }

  Widget _buildGroupsTab() {
    return FutureBuilder<List<GroupData>>(
      future: _groupsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final groups = snapshot.data ?? [];
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GroupSearchResultItem(groupData: group);
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
