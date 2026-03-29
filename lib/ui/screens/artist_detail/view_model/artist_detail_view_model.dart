import 'package:flutter/material.dart';
import 'package:w10_practice_firebase_part2/data/repositories/artist/artist_repository.dart';
import 'package:w10_practice_firebase_part2/data/repositories/songs/song_repository.dart';
import 'package:w10_practice_firebase_part2/model/artist/artist.dart';
import 'package:w10_practice_firebase_part2/model/artist/comment.dart';
import 'package:w10_practice_firebase_part2/model/songs/song.dart';
import 'package:w10_practice_firebase_part2/ui/screens/library/view_model/library_item_data.dart';
import 'package:w10_practice_firebase_part2/ui/states/player_state.dart';
import 'package:w10_practice_firebase_part2/ui/utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final SongRepository songRepository;
  final PlayerState playerState;
  final Artist artist;
  AsyncValue<List<LibraryItemData>> songsData = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsData = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
    required this.playerState,
    required this.songRepository,
  }) {
    _init();
    playerState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    await fetchSongs();
    await fetchComments();
  }

  Future<void> fetchSongs() async {
    try {
      final songs = await artistRepository.fetchSongsByArtistId(artist.id);

      songsData = AsyncValue.success([
        for (var song in songs) LibraryItemData(song: song, artist: artist),
      ]);
    } catch (e) {
      songsData = AsyncValue.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchComments() async {
    try {
      commentsData = AsyncValue.success(
        await artistRepository.fetchCommentsByArtistId(artist.id),
      );
    } catch (e) {
      commentsData = AsyncValue.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<bool> addComment(Comment comment) async {
    final result = await artistRepository.addComment(comment);
    if (commentsData.state == AsyncValueState.success) {
      commentsData.data!.add(result);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> incrSongLikeCount(LibraryItemData itemData) async {
    if (songsData.state == AsyncValueState.success) {
      final songIndex = songsData.data!.indexWhere(
        (e) => e.song.id == itemData.song.id,
      );
      songsData.data!.replaceRange(songIndex, songIndex + 1, [
        LibraryItemData(
          song: itemData.song.copyWith(likeCount: itemData.song.likeCount + 1),
          artist: itemData.artist,
        ),
      ]);
      notifyListeners();
      Song? result = await songRepository.updateSongLikeCount(itemData.song);

      if (result != null) {
        songsData.data!.replaceRange(songIndex, songIndex + 1, [
          LibraryItemData(song: result, artist: itemData.artist),
        ]);
      } else {
        songsData.data!.replaceRange(songIndex, songIndex + 1, [
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
