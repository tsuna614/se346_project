import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/app-screens/social/other_people_profile_screen.dart';
import 'package:se346_project/src/widgets/groupPage.dart';
import 'package:se346_project/src/widgets/addGroupScreen.dart';

class SocialScreen extends StatefulWidget {
  final void Function() alternateDrawer;

  const SocialScreen({Key? key, required this.alternateDrawer})
      : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final int limit = 7;
  int page = 1;
  int totalUsers = 0;
  int _currentIndex = 0; // Track the currently selected tab index
  List<UserProfileData> _searchResults = [];
  List<GroupData> _searchResultsGroup = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _searchUser({bool isLoadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final results = await GeneralAPI()
        .searchUser(_searchController.text, limit: limit, page: page);
    final total = await GeneralAPI().getUserCount(_searchController.text);

    setState(() {
      if (isLoadMore) {
        _searchResults.addAll(results);
      } else {
        _searchResults = results;
      }
      totalUsers = total;
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_searchResults.length < totalUsers) {
        setState(() {
          page++;
        });
        _searchUser(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.green),
          onPressed: () {
            widget.alternateDrawer();
          },
        ),
        title: Text('Social',
            style: TextStyle(
                color: Colors.green,
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildGroupsTab(),
        ],
      ),
      floatingActionButton: _currentIndex == 1 // Show FAB only on Groups tab
          ? FloatingActionButton(
              onPressed: () async {
                final newGroup = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateGroupScreen(),
                  ),
                );
                if (newGroup != null) {
                  // Add the new group to the list
                  // This is a temporary implementation
                  // setState(() {
                  //   _searchResults.insert(0, newGroup);
                  // });
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }

  Widget _buildFriendsTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Search for Friends',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter a name or email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                page = 1;
                _searchResults.clear();
              });
              _searchUser();
            },
            child: Text('Search'),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _searchResults.length + 1,
              itemBuilder: (context, index) {
                if (index == _searchResults.length) {
                  return _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox();
                }
                final user = _searchResults[index];
                return SocialFriendItem(profileData: user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Search for Groups',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _groupNameController,
            decoration: InputDecoration(
              hintText: 'Enter a group name or topic',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              final results =
                  await GeneralAPI().searchGroup(_groupNameController.text);

              setState(() {
                _isLoading = false;
                _searchResultsGroup.clear();
                if (results != null) {
                  _searchResultsGroup = results;
                }
              });
            },
            child: Text('Search'),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResultsGroup.length,
                    itemBuilder: (context, index) {
                      final group = _searchResultsGroup[index];
                      return GroupSearchResultItem(groupData: group);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class SocialFriendItem extends StatelessWidget {
  final UserProfileData profileData;

  const SocialFriendItem({Key? key, required this.profileData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtherProfile(profileData: profileData),
        ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(profileData.name),
          subtitle: Text(profileData.email),
          trailing: ElevatedButton(
            onPressed: () {
              //Todo Action when adding friend
            },
            child: Text('Follow'),
          ),
        ),
      ),
    );
  }
}
