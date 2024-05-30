import 'package:flutter/material.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/widgets/post.dart';
import 'package:se346_project/src/widgets/addPostScreen.dart';

class GroupPage extends StatefulWidget {
  final GroupData groupData;

  const GroupPage({
    super.key,
    required this.groupData,
  });

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late GroupData groupData;

  @override
  void initState() {
    super.initState();
    groupData = widget.groupData;
  }

  void onJoinGroup() async {
    await groupData.joinGroup();
    setState(() {
      // Refresh the UI after joining the group
    });
  }

  void onQuitGroup(BuildContext context) async {
    await groupData.leaveGroup();
    Navigator.pop(context);
  }

  void onAddPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddPostScreen(groupId: groupData.id, groupName: groupData.name),
      ),
    );
    setState(() {
      // Refresh the UI after adding a post
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupData.name),
        actions: groupData.isMember
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => onAddPost(context),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (groupData.bannerImgUrl != null)
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: groupData.bannerImgUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.white, size: 50),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupData.name,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    groupData.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 16.0),
                  if (!groupData.isMember)
                    ElevatedButton(
                      onPressed: onJoinGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                      ),
                      child: Text('Join Group',
                          style: TextStyle(color: Colors.white)),
                    ),
                  if (groupData.isMember)
                    ElevatedButton(
                      onPressed: () => onQuitGroup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                      ),
                      child: Text('Quit Group',
                          style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.grey[300],
            ),
            if (groupData.isMember)
              FutureBuilder<List<PostData>>(
                future: groupData.getGroupPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading posts'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts available'));
                  } else {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Post(postData: post);
                      },
                    );
                  }
                },
              ),
          ],
        ),
      ),
      floatingActionButton: groupData.isMember
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () => onAddPost(context),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}

class GroupSearchResultItem extends StatelessWidget {
  final GroupData groupData;

  const GroupSearchResultItem({
    super.key,
    required this.groupData,
  });

  String shortDescription() {
    if (groupData.description.length > 50) {
      return groupData.description.substring(0, 50) + '...';
    }
    return groupData.description;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: groupData.bannerImgUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: groupData.bannerImgUrl != null &&
                        groupData.bannerImgUrl!.isNotEmpty
                    ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: groupData.bannerImgUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child:
                                Icon(Icons.error, color: Colors.red, size: 24),
                          );
                        },
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, color: Colors.white),
                      ),
              )
            : CircleAvatar(
                backgroundColor: Colors.primaries[
                    DateTime.now().microsecondsSinceEpoch %
                        Colors.primaries.length],
                child: Text(
                  groupData.name[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
        title: Text(
          groupData.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(shortDescription()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupPage(groupData: groupData),
            ),
          );
        },
      ),
    );
  }
}
