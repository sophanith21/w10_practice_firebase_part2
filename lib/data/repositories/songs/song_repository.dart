import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs();

  Future<Song?> fetchSongById(String id);

  Future<Song?> updateSongLikeCount(Song song);
}
