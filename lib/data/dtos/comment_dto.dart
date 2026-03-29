import 'package:w10_practice_firebase_part2/model/artist/comment.dart';

class CommentDto {
  static const String idKey = 'id';
  static const String textKey = 'text';
  static const String createdAtKey = 'createdAt';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[textKey] is String);
    assert(json[createdAtKey] is String);

    return Comment(
      id: id,
      text: json[textKey],
      createdAt: DateTime.parse(json[createdAtKey]),
    );
  }

  /// Convert Comment to JSON for Firebase
  static Map<String, dynamic> toJson(Comment comment) {
    return {
      textKey: comment.text,
      createdAtKey: comment.createdAt.toIso8601String(),
    };
  }
}
