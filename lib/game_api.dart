import 'dart:convert';
import 'package:http/http.dart' as http;
import 'game.dart';

class GetApi {
  static const String url = 'https://www.freetogame.com/api/games?platform=pc';

  static Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Game.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }
}
