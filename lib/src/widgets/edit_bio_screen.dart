import 'package:flutter/material.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';

class EditBioScreen extends StatefulWidget {
  UserProfileData profile;
  EditBioScreen(this.profile, {Key? key});
  @override
  _EditBioScreenState createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  String _bio = '';
  bool hasError = false;
  bool isSaving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add change to your bio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Enter your new bio'),
              onChanged: (value) {
                setState(() {
                  _bio = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_bio.isEmpty) {
                  setState(() {
                    hasError = true;
                  });
                  return;
                }
                setState(() {
                  isSaving = true;
                });
                await GeneralAPI().changeBio(_bio);
                Navigator.pop(context);
              },
              child: isSaving ? CircularProgressIndicator() : Text('Save'),
            ),
            if (hasError)
              Text(
                'Bio cannot be empty',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
