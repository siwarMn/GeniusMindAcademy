class ForumAnswer {
  final String id;
  final String questionId;
  final String author;
  final String content;
  final int votes;
  final DateTime createdAt;
  final bool isAccepted;
  final List<String> upvotedBy;
  final List<String> downvotedBy;

  ForumAnswer({
    required this.id,
    required this.questionId,
    required this.author,
    required this.content,
    this.votes = 0,
    required this.createdAt,
    this.isAccepted = false,
    this.upvotedBy = const [],
    this.downvotedBy = const [],
  });
}

class ForumQuestion {
  final String id;
  final String title;
  final String description;
  final String author;
  final List<String> tags;
  final int votes;
  final int views;
  final DateTime createdAt;
  final List<ForumAnswer> answers;
  final List<String> upvotedBy;
  final List<String> downvotedBy;

  ForumQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.tags,
    this.votes = 0,
    this.views = 0,
    required this.createdAt,
    this.answers = const [],
    this.upvotedBy = const [],
    this.downvotedBy = const [],
  });

  bool get hasAcceptedAnswer =>
      answers.any((answer) => answer.isAccepted);

  int get answerCount => answers.length;
}
