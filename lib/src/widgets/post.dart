import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/blocs/CommentBloc.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/detailedPost.dart';
import 'package:se346_project/src/utils/convertTime.dart';

const _avatarSize = 40.0;

class Post extends StatefulWidget {
  final PostData postData;
  //refresh function for parent widget
  final void Function()? refreshPreviousScreen;

  Post({Key? key, required this.postData, this.refreshPreviousScreen})
      : super(key: key);
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController reportController = TextEditingController();
  void onLike() async {
    await widget.postData.likePost();
  }

  void onComment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(),
          child: DetailedPostPage(postData: widget.postData),
        ),
      ),
    );
  }

  void onShare() async {
    await widget.postData.sharePost();
    // Show snackbar
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post shared'),
      ),
    );
  }

  void onDelete() async {
    //Show confirmation dialog then delete
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Logic for deleting the post
      await widget.postData.deletePost();
      // Refresh parent widget
      if (widget.refreshPreviousScreen != null) {
        widget.refreshPreviousScreen!();
      }
    }
  }

  void onReport() async {
    //Clear
    reportController.clear();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reportController,
                decoration: InputDecoration(
                  hintText: 'Reason for reporting',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, reportController.text),
              child: Text('Report'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await widget.postData.reportPost(result);

      // Show snackbar
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post reported'),
        ),
      );
    }
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
                    widget.postData.posterAvatarUrl != "")
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    child: ClipOval(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.postData.posterAvatarUrl!,
                        fit: BoxFit.cover,
                        width: _avatarSize,
                        height: _avatarSize,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: _avatarSize,
                            height: _avatarSize,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  )
                else
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    child: Icon(Icons.person),
                  ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String?>(
                      future: widget.postData.getGroupName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(widget.postData.name);
                        } else if (snapshot.hasError) {
                          return Text(widget.postData.name);
                        } else {
                          final groupName = snapshot.data;
                          return RichText(
                            text: TextSpan(
                              text: widget.postData.name,
                              style: DefaultTextStyle.of(context).style,
                              children: groupName != null
                                  ? [
                                      TextSpan(
                                          text: ' > ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          )),
                                      TextSpan(
                                        text: groupName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                          );
                        }
                      },
                    ),
                    Text(
                      convertTime(widget.postData.createdAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    } else if (value == 'report') {
                      onReport();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return widget.postData.userIsPoster == true
                        ? [
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete Post'),
                            ),
                          ]
                        : [
                            PopupMenuItem<String>(
                              value: 'report',
                              child: Text('Report Post'),
                            ),
                          ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.postData.content),
                if (widget.postData.mediaUrl != null &&
                    widget.postData.mediaUrl != "")
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
                if (widget.postData.sharePostId != null)
                  FutureBuilder<PostData?>(
                    future: widget.postData.fetchSharedPost(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading shared post');
                      } else if (snapshot.hasData) {
                        final sharedPost = snapshot.data!;
                        return Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (sharedPost.posterAvatarUrl != null &&
                                        sharedPost.posterAvatarUrl != "")
                                      CircleAvatar(
                                        radius: _avatarSize / 2,
                                        child: ClipOval(
                                          child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: sharedPost.posterAvatarUrl!,
                                            fit: BoxFit.cover,
                                            width: _avatarSize,
                                            height: _avatarSize,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: _avatarSize,
                                                height: _avatarSize,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    else
                                      CircleAvatar(
                                        radius: _avatarSize / 2,
                                        child: Icon(Icons.person),
                                      ),
                                    const SizedBox(width: 8.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(sharedPost.name),
                                        Text(
                                          convertTime(sharedPost.createdAt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(sharedPost.content),
                                if (sharedPost.mediaUrl != null)
                                  FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: sharedPost.mediaUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 200,
                                        color: Colors.grey[300],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
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
                      color: widget.postData.userLiked ?? false
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${widget.postData.likes?.length ?? 0}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.postData.comments.length} comments',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(width: 8.0),
                    if (widget.postData.groupId == null)
                      Text(
                        '${widget.postData.shares?.length ?? 0} shares',
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
                      icon: Icon(Icons.thumb_up,
                          color: widget.postData.userLiked ?? false
                              ? Colors.blue
                              : Colors.grey),
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
                    if (widget.postData.groupId == null &&
                        widget.postData.sharePostId == null &&
                        widget.postData.userIsPoster != true)
                      IconButton(
                        icon: const Icon(Icons.share),
                        // Show confirmation dialog then share
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Share post'),
                                content: Text(
                                    'Are you sure you want to share this post?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text('Share'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (result == true) {
                            onShare();
                          }
                        },
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      (widget.postData.groupId == null &&
                              widget.postData.sharePostId == null &&
                              widget.postData.userIsPoster != true)
                          ? 'Share'
                          : 'Cannot share',
                      style: TextStyle(
                        color: (widget.postData.groupId == null &&
                                widget.postData.sharePostId == null &&
                                widget.postData.userIsPoster != true)
                            ? Colors.black
                            : Colors.grey,
                      ),
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
