import 'package:flutter/material.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/edit_bio_screen.dart';
import 'package:se346_project/src/widgets/edit_name_screen.dart';
import 'package:se346_project/src/widgets/edit_avatar_screen.dart';
import 'package:se346_project/src/widgets/edit_background_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfileData profile;
  EditProfileScreen(this.profile, {Key? key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[200], // Match the background color of the ProfileScreen
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor:
            Colors.green, // Match the app bar color of the ProfileScreen
        title: Text(
          'Choose what to edit',
          style: TextStyle(
            color: Colors
                .white, // Match the text color of the ProfileScreen app bar
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          buildEditOption(
            context,
            'Change your bio',
            EditBioScreen(widget.profile),
          ),
          buildEditOption(
            context,
            'Change your name',
            EditNameScreen(widget.profile),
          ),
          buildEditOption(
            context,
            'Upload new avatar',
            EditAvatarScreen(widget.profile),
          ),
          buildEditOption(
            context,
            'Change profile background',
            EditProfileBackgroundScreen(widget.profile),
          ),
        ],
      ),
    );
  }

  Widget buildEditOption(BuildContext context, String title, Widget screen) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors
                .green, // Match the text color of the ProfileScreen options
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
