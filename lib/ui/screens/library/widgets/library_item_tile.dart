import 'package:flutter/material.dart';
import 'package:w10_practice_firebase_part2/ui/states/player_state.dart';
import '../view_model/library_item_data.dart';

class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.onTap,
    required this.onLike,
  });

  final LibraryItemData data;
  final bool isPlaying;
  final VoidCallback onTap;
  final ValueChanged<LibraryItemData> onLike;
  @override
  Widget build(BuildContext context) {
    String likeSuffix = data.song.likeCount > 1 ? "likes" : "like";
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(data.song.title),
          subtitle: Wrap(
            children: [
              Text("${data.song.duration.inMinutes} mins"),
              SizedBox(width: 20),
              Text("${data.song.likeCount} $likeSuffix"),
              SizedBox(width: 20),
              Text(data.artist.name),
              SizedBox(width: 20),
              Text(data.artist.genre),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.song.imageUrl.toString()),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPlaying ? "Playing" : "",
                style: TextStyle(color: Colors.amber),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () => onLike(data),
                icon: Icon(Icons.thumb_up),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
