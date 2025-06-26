import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:airlineapp/models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final double indent;
  final bool isReply;
  final void Function(Comment) onReply;
  final VoidCallback? onUpvote;
  final String currentUserName;

  const CommentItem({
    Key? key,
    required this.comment,
    this.indent = 0,
    this.isReply = false,
    required this.onReply,
    this.onUpvote,
    required this.currentUserName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent, top: 8, bottom: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header row: avatar, name & time on left, upvotes on right (hidden for replies)
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.avatarUrl),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                if (!isReply)
                  Text(
                    '${comment.upvotes} Upvotes',
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // comment text
            Text(comment.text),

            const SizedBox(height: 12),

            // action row
            Row(
              children: [
                // Upvote (hidden for replies)
                if (!isReply)
                  GestureDetector(
                    onTap: comment.canUpvote(currentUserName) ? onUpvote : null,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/upvote.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Upvote',
                          style: TextStyle(
                            color: comment.canUpvote(currentUserName)
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (!isReply) const SizedBox(width: 24),

                // Reply
                GestureDetector(
                  onTap: () => onReply(comment),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/reply.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text('Reply', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),

            // nested replies
            for (var reply in comment.replies)
              CommentItem(
                comment: reply,
                indent: indent + 24,
                isReply: true,
                onReply: onReply,

                onUpvote: onUpvote,
                currentUserName: currentUserName,
              ),
          ],
        ),
      ),
    );
  }
}
