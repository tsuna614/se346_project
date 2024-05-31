import 'package:flutter/material.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';

class EditNameScreen extends StatefulWidget {
  UserProfileData profile;
  EditNameScreen(this.profile, {Key? key});
  @override
  _EditNameScreenState createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  String _name = '';
  bool isSaving = false;
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Enter your new name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_name.isEmpty) {
                  setState(() {
                    hasError = true;
                  });
                  return;
                }
                setState(() {
                  isSaving = true;
                });
                await GeneralAPI().changeName(_name);
                Navigator.pop(context);
              },
              child: isSaving ? CircularProgressIndicator() : Text('Save'),
            ),
            if (hasError)
              Text(
                'Name cannot be empty',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
