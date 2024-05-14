import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/blocs/CommentBloc.dart';

const _avatarSize = 40.0;

class Post extends StatelessWidget {
  final String id;
  final String name;
  final String content;
  final List<dynamic> comments;
  final String? avatarUrl;
  final String? mediaUrl;
  const Post({
    super.key,
    required this.id,
    required this.name,
    required this.content,
    this.comments = const [],
    this.avatarUrl,
    this.mediaUrl,
  });

  void onLike() {
    // Handle like action
  }
  //A sample implementation of onComment.
  //Todo: replace it with api fetching later.
  void onComment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(),
          child: CommentPage(
              commentBloc: CommentBloc(),
              comments: comments,
              postData: PostData(
                id: id,
                name: name,
                content: content,
                comments: comments,
                avatarUrl: avatarUrl,
                mediaUrl: mediaUrl,
              )),
        ),
      ),
    );
  }

  void onShare() {
    // Handle share action
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (avatarUrl != null)
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundImage: NetworkImage(avatarUrl!),
                  )
                else
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundColor: Colors.primaries[
                        DateTime.now().microsecondsSinceEpoch %
                            Colors.primaries.length],
                  ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(
                      '2 hours ago',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content),
                if (mediaUrl != null)
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: mediaUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '1',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${comments.length} comments',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '0 shares',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: onLike,
                    ),
                    Text('Like'),
                  ],
                ),
                GestureDetector(
                  onTap: () => onComment(context),
                  child: Row(
                    children: [
                      Icon(Icons.comment),
                      SizedBox(width: 4.0),
                      Text('Comment'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: onShare,
                    ),
                    Text('Share'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentPage extends StatefulWidget {
  final CommentBloc commentBloc;
  final List<dynamic> comments; // Receive comments here
  final PostData postData; // Pass the original post data here

  const CommentPage({
    Key? key,
    required this.commentBloc,
    required this.comments,
    required this.postData,
  }) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Center(
          child: Text(widget.postData.name),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostForCommentPage(
              name: widget.postData.name,
              content: widget.postData.content,
              comments: widget.postData.comments,
              commentBloc: widget.commentBloc,
              avatarUrl: widget.postData.avatarUrl,
              mediaUrl: widget.postData.mediaUrl,
            ),
            // Add some spacing
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your comment...',
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                widget.commentBloc.commentEventSink
                    .add(AddComment(_commentController.text));
                _commentController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.commentBloc.dispose();
    super.dispose();
  }
}

class CommentItem extends StatefulWidget {
  final String text;
  final String? image;
  final String name;
  final VoidCallback onRemove;

  const CommentItem({
    Key? key,
    required this.text,
    this.image,
    required this.name,
    required this.onRemove,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Comment avatar
                Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Text(widget.name[0]),
                    ),
                  ],
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Comment name and text
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor ?? Colors.grey[300],
                        border: Border.all(
                          //Todo apply theme later
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('2 hours ago',
                              style: Theme.of(context).textTheme.caption),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(widget.text,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                    ),
                    //Comment image
                    if (widget.image != null)
                      Column(
                        children: [
                          SizedBox(height: 4.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: widget.image!,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[300],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostForCommentPage extends StatelessWidget {
  final String name;
  final String content;
  final List<dynamic> comments;
  final String? avatarUrl;
  final String? mediaUrl;
  final CommentBloc commentBloc;

  const PostForCommentPage({
    super.key,
    required this.name,
    required this.content,
    this.comments = const [],
    required this.commentBloc,
    this.avatarUrl,
    this.mediaUrl,
  });

  void onLike() {
    // Handle like action
  }
  void onShare() {
    // Handle share action
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (avatarUrl != null)
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundImage: NetworkImage(avatarUrl!),
                  )
                else
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundColor: Colors.primaries[
                        DateTime.now().microsecondsSinceEpoch %
                            Colors.primaries.length],
                  ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(
                      '2 hours ago',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(content, textAlign: TextAlign.left),
                ),
                if (mediaUrl != null)
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: mediaUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '1',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${comments.length} comments',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '0 shares',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                //Remove comment button
              ],
            ),
            Divider(
              color: Color.fromARGB(123, 158, 158, 158),
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: onLike,
                    ),
                    Text('Like'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: onShare,
                    ),
                    Text('Share'),
                  ],
                ),
              ],
            ),
            //Add comments
            Divider(
              color: Color.fromARGB(123, 158, 158, 158),
              thickness: 1,
            ),
            for (var comment in this.comments)
              CommentItem(
                text: comment['text'],
                image: comment['image'],
                name: comment['name'],
                onRemove: () {
                  this
                      .commentBloc
                      .commentEventSink
                      .add(RemoveComment(comment['id']));
                },
              ),
          ],
        ),
      ),
    );
  }
}

class PostData {
  final String id;
  final String name; //poster
  final String content;
  final List<dynamic> comments;
  final String? avatarUrl;
  final String? mediaUrl;

  PostData({
    required this.id,
    required this.name,
    required this.content,
    this.comments = const [],
    this.avatarUrl,
    this.mediaUrl,
  });
}
