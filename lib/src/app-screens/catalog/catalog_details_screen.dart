import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se346_project/src/data/global_data.dart' as globals;
import 'package:se346_project/src/provider/user_provider.dart';

class CatalogDetailsScreen extends StatefulWidget {
  final String designPatternName;
  const CatalogDetailsScreen({super.key, required this.designPatternName});

  @override
  State<CatalogDetailsScreen> createState() => _CatalogDetailsScreenState();
}

class _CatalogDetailsScreenState extends State<CatalogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> bookmarks = Provider.of<UserProvider>(context).bookmarksTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.designPatternName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              bookmarks.contains(widget.designPatternName)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
            color: Colors.black,
            onPressed: () {
              setState(() {
                if (bookmarks.contains(widget.designPatternName)) {
                  Provider.of<UserProvider>(context, listen: false)
                      .removeBookmark(title: widget.designPatternName);
                } else {
                  Provider.of<UserProvider>(context, listen: false)
                      .addBookmark(title: widget.designPatternName);
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...globals.contents[widget.designPatternName] ??
              [const Text('No content')],
        ],
      ),
    );
  }
}
