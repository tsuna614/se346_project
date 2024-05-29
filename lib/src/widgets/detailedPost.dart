//Show posts and comments
import 'package:flutter/material.dart';
import 'package:se346_project/src/blocs/CommentBloc.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/commentItem.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/utils/convertTime.dart';

const _avatarSize = 40.0;

class DetailedPostPage extends StatefulWidget {
  final CommentBloc commentBloc;
  final List<CommentData> comments; // Receive comments here
  final PostData postData; // Pass the original post data here

  const DetailedPostPage({
    Key? key,
    required this.commentBloc,
    required this.comments,
    required this.postData,
  }) : super(key: key);

  @override
  _DetailedPostPageState createState() => _DetailedPostPageState();
}

class _DetailedPostPageState extends State<DetailedPostPage> {
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
            PostAndCommentInDetailedPage(
              name: widget.postData.name,
              content: widget.postData.content,
              comments: widget.postData.comments,
              commentBloc: widget.commentBloc,
              avatarUrl: widget.postData.posterAvatarUrl,
              mediaUrl: widget.postData.mediaUrl,
              postId: widget.postData.id,
              userId: widget.postData.posterId,
              sharesCount: widget.postData.shares?.length ?? 0,
              createdAt: widget.postData.createdAt,
              likesCount: widget.postData.likes?.length ?? 0,
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

class PostAndCommentInDetailedPage extends StatelessWidget {
  final String name;
  final String content;
  final List<dynamic> comments;
  final String? avatarUrl;
  final String? mediaUrl;
  final String? postId;
  final String? userId;
  final int sharesCount;
  final int likesCount;
  final DateTime createdAt;
  final CommentBloc commentBloc;

  const PostAndCommentInDetailedPage({
    super.key,
    required this.name,
    required this.content,
    this.comments = const [],
    required this.commentBloc,
    this.avatarUrl,
    this.mediaUrl,
    this.postId,
    this.userId,
    this.sharesCount = 0,
    this.likesCount = 0,
    required this.createdAt,
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
                if (avatarUrl != null && avatarUrl!.isNotEmpty)
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundImage: NetworkImage(avatarUrl!),
                  )
                else
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundColor: Colors.green,
                  ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text(
                      convertTime(createdAt),
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
                      '${likesCount} likes',
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
                      '${sharesCount} shares',
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
                comment: comment,
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
