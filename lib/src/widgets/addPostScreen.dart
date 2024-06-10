import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/api/groupAPI.dart';

class AddPostScreen extends StatefulWidget {
  final String? groupId;
  final String? groupName;
  final bool? shareMode;
  final String? sharePostId;

  const AddPostScreen(
      {Key? key,
      this.groupId,
      this.shareMode,
      this.sharePostId,
      this.groupName})
      : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  bool _isAddingPost = false; // Track loading state

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {}
  }

  void _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _addPost() async {
    setState(() {
      _isAddingPost = true; // Start loading
    });
    if (_contentController.text.isEmpty) {
      setState(() {
        _isAddingPost = false; // Stop loading
      });
      return;
    }

    if (widget.groupId != null) {
      final result = await GroupAPI().postToGroup(
        widget.groupId!,
        _contentController.text,
        _selectedImage != null ? _selectedImage : null,
      );

      setState(() {
        _isAddingPost = false; // Stop loading
      });

      // ignore: unnecessary_null_comparison
      if (result != null) {
        Navigator.pop(context, true); // Indicate success
      }
//
      return; // Ensure we don't continue to the wall posting logic
    }

    //This is for wall posting
    final result = await GeneralAPI().addPostToWall(
      _contentController.text,
      _selectedImage != null ? _selectedImage : null,
      widget.shareMode == true ? widget.sharePostId : null,
    );

    setState(() {
      _isAddingPost = false; // Stop loading
    });

    if (result != null) {
      Navigator.pop(context, true); // Indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Post${widget.groupName != null ? ' to ${widget.groupName}' : ''}',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null, // Allow unlimited lines
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Your post content...',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _getImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.fill,
                      )
                    : Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAddingPost ? null : _addPost,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: _isAddingPost
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Add Post',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
