import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w10_practice_firebase_part2/model/artist/comment.dart';
import 'package:w10_practice_firebase_part2/ui/screens/artist_detail/view_model/artist_detail_view_model.dart';
import 'package:w10_practice_firebase_part2/ui/screens/artists/view_model/artists_view_model.dart';
import 'package:w10_practice_firebase_part2/ui/screens/library/view_model/library_item_data.dart';
import 'package:w10_practice_firebase_part2/ui/screens/library/widgets/library_item_tile.dart';
import 'package:w10_practice_firebase_part2/ui/theme/theme.dart';
import 'package:w10_practice_firebase_part2/ui/utils/async_value.dart';
import 'package:w10_practice_firebase_part2/ui/widgets/artist/comment_tile.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({super.key});

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  int currentIndex = 0;
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void onAddComment() async {
    var vm = context.read<ArtistDetailViewModel>();
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400, // Fixed height or use dynamic content
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              TextField(controller: commentController),
              FilledButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    Comment comment = Comment(
                      id: '',
                      text: commentController.text,
                      createdAt: DateTime.now(),
                    );
                    Navigator.pop(context, comment);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: SizedBox(
                          height: 100,
                          width: 200,
                          child: Center(child: Text("Your comment is empty!")),
                        ),
                      ),
                    );
                  }
                },
                child: Text("Post comment"),
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      if (await vm.addComment(result)) {
        commentController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ArtistDetailViewModel vm = context.watch<ArtistDetailViewModel>();

    AsyncValue<List<LibraryItemData>> songsAsyncValue = vm.songsData;

    AsyncValue<List<Comment>> commentsAsyncValue = vm.commentsData;

    Widget songsContent;
    switch (songsAsyncValue.state) {
      case AsyncValueState.loading:
        songsContent = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        songsContent = Center(
          child: Text(
            'error = ${songsAsyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );

      case AsyncValueState.success:
        List<LibraryItemData> data = songsAsyncValue.data!;
        songsContent = ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) => LibraryItemTile(
            data: data[index],
            isPlaying: vm.isSongPlaying(data[index].song),
            onTap: () {
              vm.start(data[index].song);
            },
            onLike: vm.incrSongLikeCount,
          ),
        );
    }

    Widget commentsContent;
    switch (commentsAsyncValue.state) {
      case AsyncValueState.loading:
        commentsContent = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        commentsContent = Center(
          child: Text(
            'error = ${commentsAsyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );

      case AsyncValueState.success:
        List<Comment> data = commentsAsyncValue.data!;
        commentsContent = ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) => CommentTile(comment: data[index]),
        );
    }

    return Scaffold(
      appBar: AppBar(title: Text(vm.artist.name, style: AppTextStyles.heading)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IndexedStack(
          index: currentIndex,
          children: [
            songsContent,
            Scaffold(
              body: commentsContent,
              bottomNavigationBar: FilledButton(
                onPressed: () {
                  onAddComment();
                },
                child: Text("Add Comment"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.lightBlue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: "Artist's Song",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comments"),
        ],
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
      ),
    );
  }
}
