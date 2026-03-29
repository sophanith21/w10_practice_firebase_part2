import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:w10_practice_firebase_part2/data/dtos/comment_dto.dart';
import 'package:w10_practice_firebase_part2/data/dtos/song_dto.dart';
import 'package:w10_practice_firebase_part2/data/repositories/firebase_api.dart';
import 'package:w10_practice_firebase_part2/data/repositories/songs/song_repository.dart';
import 'package:w10_practice_firebase_part2/data/repositories/songs/song_repository_firebase.dart';
import 'package:w10_practice_firebase_part2/model/artist/comment.dart';
import 'package:w10_practice_firebase_part2/model/songs/song.dart';

import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(
    FirebaseApi.path,
    '/$artistCollectionKey.json',
  );
  static String artistCollectionKey = "artists";
  static String artistCommentCollectionKey = "artistComments";

  List<Artist>? _artistsCache;
  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (_artistsCache != null && !forceFetch) {
      return _artistsCache!;
    }
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> artistJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in artistJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
      _artistsCache = result;
      return result;
    } else {
      // 2- Throw exception if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return null;
  }

  @override
  Future<List<Comment>> fetchCommentsByArtistId(String artistId) async {
    final http.Response response = await http.get(
      artistsUri.replace(path: '$artistCommentCollectionKey/$artistId.json'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData == null) {
        return [];
      }

      final Map<String, dynamic> responseData = decodedData;

      List<Comment> result = [];

      for (var commentId in responseData.keys) {
        result.add(CommentDto.fromJson(commentId, responseData[commentId]));
      }
      return result;
    } else {
      // 2- Throw exception if any issue
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<Comment> addComment(Comment comment) async {
    final http.Response response = await http.post(
      artistsUri.replace(path: '$artistCommentCollectionKey.json'),
      body: jsonEncode(CommentDto.toJson(comment)),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return comment.copyWith(id: json['name']);
    } else {
      debugPrint(response.body);
      // 2- Throw exception if any issue
      throw Exception('Failed to post the comment');
    }
  }

  @override
  Future<List<Song>> fetchSongsByArtistId(String artistId) async {
    final http.Response response = await http.get(
      artistsUri.replace(
        path: '${SongRepositoryFirebase.songCollectionKey}.json',
        queryParameters: {'orderBy': '"artistId"', 'equalTo': '"$artistId"'},
      ),
    );

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      debugPrint(response.body);
      // 2- Throw exception if any issue
      throw Exception('Failed to load songs');
    }
  }
}
