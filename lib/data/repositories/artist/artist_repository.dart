import 'package:w10_practice_firebase_part2/model/artist/comment.dart';
import 'package:w10_practice_firebase_part2/model/songs/song.dart';

import '../../../model/artist/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});

  Future<Artist?> fetchArtistById(String id);

  Future<List<Song>> fetchSongsByArtistId(String artistId);

  Future<Comment> addComment(Comment comment);

  Future<List<Comment>> fetchCommentsByArtistId(String artistId);
}
