import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  final void Function() alternateDrawer;
  const SocialScreen({Key? key, required this.alternateDrawer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.green),
          onPressed: () {
            alternateDrawer();
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
              decoration: InputDecoration(
                hintText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Todo Action when searching for friends
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Todo fix sample friend count
                itemBuilder: (context, index) {
                  // Todo: Replace with actual friend data
                  final String name = 'Friend $index';
                  final String phoneNumber = '+1 123-456-789$index';

                  return SocialFriend(name: name, phoneNumber: phoneNumber);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialFriend extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const SocialFriend({
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: Text(phoneNumber),
        trailing: ElevatedButton(
          onPressed: () {
            //Todo Action when adding friend
          },
          child: Text('Add Friend'),
        ),
      ),
    );
  }
}
