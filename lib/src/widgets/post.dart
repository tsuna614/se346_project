import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/blocs/CommentBloc.dart';

const _avatarSize = 40.0;

class Post extends StatelessWidget {
  final String name;
  final String content;
  final List<dynamic> comments;
  final String? avatarUrl;
  final String? mediaUrl;
  const Post({
    super.key,
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
            comments: comments, // Pass the comments list here
          ),
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () => onComment(context),
                    ),
                    Text('Comment'),
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
          ],
        ),
      ),
    );
  }
}

class CommentPage extends StatefulWidget {
  final CommentBloc commentBloc;
  final List<dynamic> comments; // Receive comments here

  const CommentPage(
      {super.key, required this.commentBloc, required this.comments});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<CommentState>(
        stream: widget.commentBloc.commentStateStream,
        initialData: CommentsLoaded(widget.comments),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is CommentsLoaded) {
            List<dynamic> comments = (snapshot.data as CommentsLoaded).comments;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentItem(
                  text: comment['text'],
                  image: comment['image'],
                  name: comment['name'] ?? 'Anonymous',
                  onRemove: () {
                    widget.commentBloc.commentEventSink
                        .add(RemoveComment(index));
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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

class CommentItem extends StatelessWidget {
  final String text;
  final String? image;
  final String name;
  final VoidCallback onRemove;

  const CommentItem({
    super.key,
    required this.text,
    this.image,
    required this.name,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    // You can add avatarUrl logic here
                    child: Text(name[
                        0]), // Displaying first character of name as avatar
                  ),
                  const SizedBox(width: 8.0),
                  Text(name),
                ],
              ),
              const SizedBox(height: 8.0),
              if (image != null)
                FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: image!,
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
              if (image != null) const SizedBox(height: 8.0),
              Text(text),
              const SizedBox(height: 8),
              //Todo: implement user checking to allow for removal.
              // ElevatedButton(
              //   onPressed: onRemove,
              //   child: Text('Remove'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
