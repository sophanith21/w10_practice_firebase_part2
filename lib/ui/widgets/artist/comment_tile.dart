import 'package:flutter/material.dart';
import 'package:w10_practice_firebase_part2/model/artist/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(comment.text),
          subtitle: Text("Posted: ${comment.createdAt}"),
          leading: Icon(Icons.comment),
        ),
      ),
    );
  }
}
