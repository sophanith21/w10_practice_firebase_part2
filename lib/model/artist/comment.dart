class Comment {
  final String id;
  final String text;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Comment copyWith({String? id, String? text, DateTime? createdAt}) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt)';
  }
}
