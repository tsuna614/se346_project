import 'package:flutter/material.dart';
import 'package:se346_project/src/blocs/CommentBloc.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/commentItem.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/utils/convertTime.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const _avatarSize = 40.0;

class DetailedPostPage extends StatefulWidget {
  final CommentBloc commentBloc;
  final PostData postData; // Pass the original post data here

  const DetailedPostPage({
    Key? key,
    required this.commentBloc,
    required this.postData,
  }) : super(key: key);

  @override
  _DetailedPostPageState createState() => _DetailedPostPageState();
}

class _DetailedPostPageState extends State<DetailedPostPage> {
  TextEditingController _commentController = TextEditingController();
  List<CommentData> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments = widget.postData.comments;
    _setupSocket();
  }

  void _setupSocket() {
    IO.Socket socket = IO.io('http://sv', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      print('connected');
    });

    socket.on('new_comment', (data) {
      setState(() {
        _comments.add(CommentData.fromJson(data));
      });
    });

    socket.on('disconnect', (_) {
      print('disconnected');
    });
  }

  Future<void> _loadComments() async {
    // Here you would fetch comments from your backend or other source
    // For this example, we'll assume comments are already in widget.postData.comments
    setState(() {
      _comments = widget.postData.comments;
    });
  }

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
              postData: widget.postData,
              comments: _comments,
              onCommentAdded: _loadComments,
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
                _loadComments();
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

class PostAndCommentInDetailedPage extends StatefulWidget {
  final PostData postData;
  final List<CommentData> comments;
  final Function onCommentAdded;

  PostAndCommentInDetailedPage({
    Key? key,
    required this.postData,
    required this.comments,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  State<PostAndCommentInDetailedPage> createState() =>
      _PostAndCommentInDetailedPageState();
}

class _PostAndCommentInDetailedPageState
    extends State<PostAndCommentInDetailedPage> {
  void onLike() async {
    await widget.postData.likePost();
    setState(() {});
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
                if (widget.postData.posterAvatarUrl != null &&
                    widget.postData.posterAvatarUrl!.isNotEmpty)
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundImage:
                        NetworkImage(widget.postData.posterAvatarUrl!),
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
                    Text(widget.postData.name),
                    Text(
                      convertTime(widget.postData.createdAt),
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
                  child:
                      Text(widget.postData.content, textAlign: TextAlign.left),
                ),
                if (widget.postData.mediaUrl != null)
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.postData.mediaUrl!,
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
                      '${widget.postData.likes?.length ?? 0} likes',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.comments.length} comments',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${widget.postData.shares?.length ?? 0} shares',
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
                      icon: Icon(
                        Icons.thumb_up,
                        color: widget.postData.userLiked ?? false
                            ? Colors.blue
                            : Colors.grey,
                      ),
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
            for (var comment in widget.comments)
              CommentItem(
                comment: comment,
                onRemove: () {
                  // Todo Handle remove comment action
                },
              ),
          ],
        ),
      ),
    );
  }
}
