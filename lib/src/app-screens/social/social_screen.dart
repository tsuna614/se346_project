import 'package:flutter/material.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/app-screens/profile/profile_screen.dart';
import 'package:se346_project/src/app-screens/social/other_people_profile_screen.dart';

class SocialScreen extends StatefulWidget {
  final void Function() alternateDrawer;

  const SocialScreen({Key? key, required this.alternateDrawer})
      : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserProfileData> _searchResults = [];

  Future<void> _searchUser() async {
    final results = await GeneralAPI().searchUser(_searchController.text);
    setState(() {
      _searchResults = results;
    });
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
      ),
      body: Padding(
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
              onPressed: _searchUser,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return SocialFriendItem(profileData: user);
                },
              ),
            ),
          ],
        ),
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
        //Todo: Push profile
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
