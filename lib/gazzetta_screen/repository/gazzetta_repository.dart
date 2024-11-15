import 'dart:convert';

import 'package:http/http.dart' as http;

class GazzettaRepository {
  static const String url =
      'https://www.gazzetta.it/dynamic-feed/rss/section/Calcio/Serie-A.xml';

  Future<String> fetchSoccerFeedData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
