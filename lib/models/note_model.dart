class Note {
  final String id;
  final String title;
  final String content;
  final String subject;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.subject,
    this.isPinned = false
  });
}