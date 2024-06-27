import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:se346_project/src/app-screens/catalog/catalog_details_screen.dart';
import 'package:se346_project/src/provider/user_provider.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  Future<void> _showMyDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning),
              SizedBox(width: 10),
              Text('Warning!'),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Delete this bookmark?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .removeBookmark(title: title);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
            TextButton(
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> bookmarks = Provider.of<UserProvider>(context).bookmarksTitle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your bookmarks'),
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (String bookmark in bookmarks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CatalogDetailsScreen(
                        designPatternName: bookmark,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(bookmark),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showMyDialog(bookmark);
                        // Provider.of<UserProvider>(context, listen: false)
                        //     .removeBookmark(title: bookmark);
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
