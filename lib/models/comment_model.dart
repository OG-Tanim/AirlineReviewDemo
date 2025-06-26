class Comment {
  final String avatarUrl;
  final String userName;
  final String timeAgo;
  final String text;
  int upvotes;
  final Set<String> upvotedBy;
  final List<Comment> replies;

  Comment({
    required this.avatarUrl,
    required this.userName,
    required this.timeAgo,
    required this.text,
    this.upvotes = 0,
    Set<String>? upvotedBy,
    List<Comment>? replies,
  }) : upvotedBy = upvotedBy ?? <String>{},
       replies = replies ?? <Comment>[];

  /// Returns true if this user hasn't yet upvoted.
  bool canUpvote(String user) => !upvotedBy.contains(user);

  /// Register an upvote (only once per user).
  void upvote(String user) {
    if (canUpvote(user)) {
      upvotes++;
      upvotedBy.add(user);
    }
  }
}
