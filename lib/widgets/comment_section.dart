import 'package:airlineapp/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'comment_item.dart';

class CommentSection extends StatefulWidget {
  final List<Comment> initialComments;
  final String currentUserAvatar;
  final String currentUserName;
  final VoidCallback? onCommentAdded;

  const CommentSection({
    Key? key,
    required this.initialComments,
    required this.currentUserAvatar,
    required this.currentUserName,
    this.onCommentAdded,
  }) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<Comment> _comments;
  Comment? _replyTo;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.initialComments);
    _sortComments();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sortComments() {
    _comments.sort((a, b) => b.upvotes.compareTo(a.upvotes));
  }

  void _onReply(Comment comment) {
    setState(() {
      _replyTo = comment;
    });
    _controller.text = '@${comment.userName} ';
    _focusNode.requestFocus();
  }

  void _addComment(String text) {
    final now = DateTime.now();
    final formattedDate = _formatDate(now);
    final comment = Comment(
      avatarUrl: widget.currentUserAvatar,
      userName: widget.currentUserName,
      timeAgo: formattedDate,
      text: text,
    );
    setState(() {
      if (_replyTo != null) {
        _replyTo!.replies.add(comment);
      } else {
        _comments.add(comment);
      }
      _sortComments();
      _replyTo = null;
      _controller.clear();
    });
    widget.onCommentAdded?.call();
  }

  void _handleUpvote(Comment c) {
    if (c.canUpvote(widget.currentUserName)) {
      setState(() {
        c.upvote(widget.currentUserName);
        _sortComments();
      });
    }
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Comment list above the input field
        for (final c in _comments)
          CommentItem(
            comment: c,
            indent: 0,
            onReply: _onReply,
            onUpvote: () => _handleUpvote(c),
            currentUserName: widget.currentUserName,
          ),
        const SizedBox(height: 8),
        // Input row styled as a pill-shaped field with embedded send icon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.currentUserAvatar),
                radius: 21,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: (txt) {
                    final trimmed = txt.trim();
                    if (trimmed.isNotEmpty) _addComment(trimmed);
                  },
                  decoration: InputDecoration(
                    hintText: 'Write your comment',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Colors.grey.shade600),
                      onPressed: () {
                        final txt = _controller.text.trim();
                        if (txt.isNotEmpty) {
                          _addComment(txt);
                        }
                      },
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      maxHeight: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
