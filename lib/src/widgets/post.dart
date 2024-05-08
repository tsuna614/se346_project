//A post widget.
// Circular avatar, if null show only random color
// Post content
// Like button - comment button - share button (spaced out evenly)

import 'package:flutter/material.dart';

const _avatarSize = 40.0;

class Post extends StatelessWidget {
  final String name;
  final String content;
  final String? avatarUrl;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const Post({
    Key? key,
    required this.name,
    required this.content,
    this.avatarUrl,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
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
                    //Random color
                    backgroundColor: Colors.primaries[
                        DateTime.now().microsecondsSinceEpoch %
                            Colors.primaries.length],
                  ),
                const SizedBox(width: 8.0),
                Text(name),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(content),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: onLike,
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: onComment,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
