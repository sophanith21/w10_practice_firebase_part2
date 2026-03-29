import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    data = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs
      List<Song> songs = await songRepository.fetchSongs();

      // 2- Fetch artist
      List<Artist> artists = await artistRepository.fetchArtists();

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

      this.data = AsyncValue.success(data);
    } catch (e) {
      // 3- Fetch is unsucessfull
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> incrSongLikeCount(LibraryItemData itemData) async {
    if (data.state == AsyncValueState.success) {
      final songIndex = data.data!.indexWhere(
        (e) => e.song.id == itemData.song.id,
      );
      data.data!.replaceRange(songIndex, songIndex + 1, [
        LibraryItemData(
          song: itemData.song.copyWith(likeCount: itemData.song.likeCount + 1),
          artist: itemData.artist,
        ),
      ]);
      notifyListeners();
      Song? result = await songRepository.updateSongLikeCount(itemData.song);

      if (result != null) {
        data.data!.replaceRange(songIndex, songIndex + 1, [
          LibraryItemData(song: result, artist: itemData.artist),
        ]);
      } else {
        data.data!.replaceRange(songIndex, songIndex + 1, [
          LibraryItemData(
            song: itemData.song.copyWith(
              likeCount: itemData.song.likeCount - 1,
            ),
            artist: itemData.artist,
          ),
        ]);
      }
      notifyListeners();
    }
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
