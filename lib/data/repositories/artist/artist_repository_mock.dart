import 'package:w10_practice_firebase_part2/model/artist/comment.dart';
import 'package:w10_practice_firebase_part2/model/songs/song.dart';

import '../../../model/artist/artist.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _artists;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }

  @override
  Future<List<Comment>> fetchCommentsByArtistId(String artistId) {
    // TODO: implement fetchCommentsByArtistId
    throw UnimplementedError();
  }

  @override
  Future<Comment> addComment(Comment comment) {
    // TODO: implement addComment
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> fetchSongsByArtistId(String artistId) {
    // TODO: implement fetchSongsByArtistId
    throw UnimplementedError();
  }
}
