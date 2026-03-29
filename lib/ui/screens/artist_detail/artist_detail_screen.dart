import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w10_practice_firebase_part2/data/repositories/artist/artist_repository.dart';
import 'package:w10_practice_firebase_part2/data/repositories/songs/song_repository.dart';
import 'package:w10_practice_firebase_part2/model/artist/artist.dart';
import 'package:w10_practice_firebase_part2/ui/screens/artist_detail/view_model/artist_detail_view_model.dart';
import 'package:w10_practice_firebase_part2/ui/screens/artist_detail/widget/artist_detail_content.dart';
import 'package:w10_practice_firebase_part2/ui/states/player_state.dart';

class ArtistDetailScreen extends StatelessWidget {
  const ArtistDetailScreen({super.key, required this.artist});
  final Artist artist;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArtistDetailViewModel(
        artistRepository: context.read<ArtistRepository>(),
        artist: artist,
        playerState: context.read<PlayerState>(),
        songRepository: context.read<SongRepository>(),
      ),
      child: ArtistDetailContent(),
    );
  }
}
