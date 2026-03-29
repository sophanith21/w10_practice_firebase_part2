import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:w10_practice_firebase_part2/data/repositories/firebase_api.dart';

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static String songCollectionKey = "songs";
  final Uri songsUri = Uri.https(FirebaseApi.path, '$songCollectionKey.json');

  List<Song>? _songsCache;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (_songsCache != null && !forceFetch) {
      return _songsCache!;
    }
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      _songsCache = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<Song?> updateSongLikeCount(Song song) async {
    final http.Response response = await http.patch(
      songsUri.replace(path: '$songCollectionKey/${song.id}.json'),
      body: jsonEncode({SongDto.likeCountKey: song.likeCount + 1}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey(SongDto.likeCountKey)) {
        return song.copyWith(likeCount: responseData[SongDto.likeCountKey]);
      }
    }
    return null;
  }
}
