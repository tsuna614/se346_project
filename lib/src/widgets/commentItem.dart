import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/utils/convertTime.dart';

class CommentItem extends StatefulWidget {
  final CommentData comment;

  final VoidCallback onRemove;

  const CommentItem({
    Key? key,
    required this.comment,
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
                // Comment avatar
                Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.comment.commenterAvatarUrl != null
                          ? NetworkImage(widget.comment.commenterAvatarUrl!)
                          : null,
                      child: widget.comment.commenterAvatarUrl == null
                          ? Text(widget.comment.commenterName[0])
                          : null,
                    ),
                  ],
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comment name and text
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).cardColor ?? Colors.grey[300],
                          border: Border.all(
                            // Todo: apply theme later
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.comment.commenterName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              '${convertTime(widget.comment.createdAt)}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(widget.comment.content,
                                  overflow: TextOverflow.visible),
                            ),
                          ],
                        ),
                      ),
                      // Comment image
                      if (widget.comment.mediaUrl != null)
                        Column(
                          children: [
                            SizedBox(height: 4.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: widget.comment.mediaUrl!,
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
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
                ),
              ],
            ),
            // Optional: Add a button to remove the comment
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: IconButton(
            //     icon: Icon(Icons.delete, color: Colors.red),
            //     onPressed: widget.onRemove,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
