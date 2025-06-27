import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import '../models/game.dart';

class GameRepository {
  
  static Future<List<Game>> loadGames() async{
    final jsonString = await rootBundle.loadString('assets/DB/games.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    List<Game> games = [];
    jsonData.forEach((key, value) {
      games.add(Game.fromJson(value));
    });
    return games;
  }

  static Future<void> saveGame(List<Game> games) async {
    final file = File('assets/DB/games.json');
    final Map<String, dynamic> jsonData = {
      for (var game in games) game.name: game.toJson(),
    };
    await file.writeAsString(json.encode(jsonData));
  }
}