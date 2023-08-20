class Note {
  int userId;
  String title;
  String content;
  DateTime createdAt;
  DateTime modifiedTime;

  Note({
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedTime,
  });
}
