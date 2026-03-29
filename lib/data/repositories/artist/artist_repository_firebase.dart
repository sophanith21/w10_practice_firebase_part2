import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:w10_practice_firebase_part2/data/repositories/firebase_api.dart';

import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(FirebaseApi.path, '/artists.json');

  List<Artist>? _artistsCache;
  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (_artistsCache != null && !forceFetch) {
      return _artistsCache!;
    }
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
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
}
