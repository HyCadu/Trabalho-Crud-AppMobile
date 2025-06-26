import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/jogo.dart';

class ApiService {
  static const String baseUrl = 'https://matemagicas-api.onrender.com/';

  // Salvar lista de usuários localmente
  static Future<void> savePlayersLocally(List<Player> players) async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = jsonEncode(players.map((p) => p.toJson()).toList());
    await prefs.setString('players', playersJson);
  }

  // Carregar lista de usuários localmente
  static Future<List<Player>> loadPlayersLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getString('players');
    if (playersJson == null) return [];
    final List<dynamic> decoded = jsonDecode(playersJson);
    return decoded.map((e) => Player.fromJson(e)).toList();
  }

  // Aluno-related methods
  static Future<List<Player>> getPlayer() async {
    final response = await http.get(Uri.parse('${baseUrl}api/users'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(
        utf8.decode(response.bodyBytes),
      );
      final List<dynamic>? items = body['items'] as List<dynamic>?;
      if (items == null) {
        return [];
      }
      return items.map((user) => Player.fromJson(user)).toList();
    } else {
      throw Exception(
        'Erro ao carregar Players. Status code: ${response.statusCode}',
      );
    }
  }

  static Future<Player> addPlayer(Player player) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/users'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(player.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Player.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception(
        'Failed to add user. Status code: ${response.statusCode} Body: ${response.body}',
      );
    }
  }

  static Future<void> deletePlayer(String id) async {
    final response = await http.delete(Uri.parse('${baseUrl}api/users/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<void> updatePlayer(String id, Player player) async {
    final response = await http.put(
      Uri.parse('${baseUrl}api/users/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(player.toJson()),
    );
  }

  // Jogo-related methods
  static Future<List<Jogo>> getJogosDoPlayer(String playerId) async {
    int page = 1;
    List<Jogo> allGames = [];
    bool hasMore = true;

    while (hasMore) {
      final response = await http.get(
        Uri.parse('${baseUrl}api/games?page=$page'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(
          utf8.decode(response.bodyBytes),
        );
        final List<dynamic>? items = body['items'] as List<dynamic>?;
        if (items != null) {
          allGames.addAll(items.map((game) => Jogo.fromJson(game)));
        }
        int totalPages = body['totalPages'] ?? 1;
        page++;
        hasMore = page <= totalPages;
      } else {
        throw Exception('Failed to load games for user');
      }
    }
    return allGames.where((jogo) => jogo.userId == playerId).toList();
  }

  static Future<Jogo> addJogo(Jogo jogo) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/games'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(jogo.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Jogo.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception(
        'Failed to add game. Status code: ${response.statusCode} Body: ${response.body}',
      );
    }
  }

  static Future<void> editarJogo(String id, Jogo jogo) async {
    final response = await http.put(
      Uri.parse('${baseUrl}api/games/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(jogo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update game');
    }
  }

  static Future<void> updateResultadoJogo(String id, Jogo jogo) async {
    final response = await http.put(
      Uri.parse('${baseUrl}api/games/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(jogo.toResultJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update game result');
    }
  }
}
