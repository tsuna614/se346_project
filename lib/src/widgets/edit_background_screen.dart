import 'dart:io';

import 'package:flutter/material.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBackgroundScreen extends StatefulWidget {
  final UserProfileData profile;
  EditProfileBackgroundScreen(this.profile, {Key? key});
  @override
  State<EditProfileBackgroundScreen> createState() =>
      _EditProfileBackgroundScreenState();
}

class _EditProfileBackgroundScreenState
    extends State<EditProfileBackgroundScreen> {
  File? _selectedImage;
  bool error = false;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Background'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _selectedImage = File(image.path);
                    error = false;
                  });
                }
              },
              child: Text('Choose new background'),
            ),
            SizedBox(height: 20),
            if (_selectedImage != null)
              Column(
                children: [
                  Image.file(
                    _selectedImage!,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedImage == null) {
                  setState(() {
                    error = true;
                  });
                  return;
                }
                setState(() {
                  isSaving = true;
                });
                await GeneralAPI().changeProfileBackground(_selectedImage!);
                Navigator.pop(context);
              },
              child: isSaving ? CircularProgressIndicator() : Text('Save'),
            ),
            if (error)
              Text(
                'Please choose an image',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
