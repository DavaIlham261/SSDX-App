// ignore_for_file: prefer_final_fields

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'package:ssdx_app/models/game.dart';
import 'package:ssdx_app/screens/content.dart';
import 'package:ssdx_app/screens/side_menu.dart';
import 'package:ssdx_app/screens/add_game_dialog.dart';
import 'package:ssdx_app/screens/edit_game_dialog.dart';
import 'package:ssdx_app/services/game_repository.dart';

// Main entry point
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Game> _games = [];
  Game? _selectedGame;
  List<Game> _filteredGames = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final loadedGames = await GameRepository.loadGames();
    setState(() {
      _games = loadedGames;
      _selectedGame = _games.isNotEmpty ? _games.first : null;
      // _isLoading = false;
    });
  }

  void _onGameSelected(Game game) {
    setState(() {
      _selectedGame = game;
    });
  }

  Future<void> _addGame() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AddNewGameDialog();
      },
    );

    if (result != null) {
      final newGame = Game(
        name: (result['name'] != null && result['name'].toString().trim().isNotEmpty)
            ? result['name']
            : 'New Game ${_games.length + 1}',
        genre: (result['genre'] != null && result['genre'].toString().trim().isNotEmpty)
            ? result['genre']
            : "No Genre",
        developer: (result['developer'] != null && result['developer'].toString().trim().isNotEmpty)
            ? result['developer']
            : 'Unknown Developer',
        releaseYear: (result['releaseYear'] != null && result['releaseYear'].toString().trim().isNotEmpty)
            ? result['releaseYear']
            : 'Unknown Year',
        description: (result['description'] != null && result['description'].toString().trim().isNotEmpty)
            ? result['description']
            : 'No Description',
        size: 'N/A',
        exePath: (result['exePath'] != null && result['exePath'].toString().trim().isNotEmpty)
            ? result['exePath']
            : '',
        folderPath: (result['folderPath'] != null && result['folderPath'].toString().trim().isNotEmpty)
            ? result['folderPath']
            : '',
      );

      print(newGame.toJson());

      final updatedGames = [..._games, newGame];

      await GameRepository.saveGame(updatedGames);

      setState(() {
        _games = updatedGames;
        _selectedGame = newGame;
      });
    }
  }

  Future<void> _editGame(Game gameToEdit) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EditGameDialog(gameToEdit: gameToEdit);
      },
    );

    if (result != null) {
      final updatedGame = Game(
        name: result['name'] ?? gameToEdit.name,
        genre: result['genre'] ?? gameToEdit.genre,
        developer: result['developer'] ?? gameToEdit.developer,
        releaseYear: result['releaseYear'] ?? gameToEdit.releaseYear,
        description: result['description'] ?? gameToEdit.description,
        size: 'N/A',
        exePath: result['exePath'] ?? gameToEdit.exePath,
        folderPath: result['folderPath'] ?? gameToEdit.folderPath,
      );

      final updatedGames =
          _games
              .map((game) => game.name == gameToEdit.name ? updatedGame : game)
              .toList();
      // print(updatedGame.toJson());

      await GameRepository.saveGame(updatedGames);

      setState(() {
        _games = updatedGames;
        _selectedGame = updatedGame;
      });
    }
  }

  Future<void> _deleteGame(Game game) async {
    // _games.removeWhere((g) => g.name == game.name);
    final updatedGames = _games.where((g) => g.name != game.name).toList();

    await GameRepository.saveGame(_games);
    setState(() {
      _games = updatedGames;
      _selectedGame = _games.isNotEmpty ? _games.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Scaffold(
      body: WindowBorder(
        color: Colors.red,
        width: 1,
        child: Stack(
          children: [
            Positioned.fill(child: BackgroundGradient()),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SideMenu(
                        games: _games,
                        selectedGame: _selectedGame,
                        filteredGames: _filteredGames,
                        onGameSelected: _onGameSelected,
                        onAddGame: _addGame,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: MainContent(
                          selectedGame: _selectedGame,
                          onEditGame: _editGame,
                          onDeleteGame: _deleteGame,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Background gradient widget
class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          // image: const NetworkImage('https://i.pinimg.com/736x/1f/99/f9/1f99f9dc6b1875fdce23f35e9081f58c.jpg'),
          // image: const AssetImage('assets/images/side_bg.jpg'),
          // image: const AssetImage('assets/images/side_bg2.jpg'),
          image: const AssetImage('assets/images/side_bg3.png'),
          // image: const AssetImage('assets/images/side_bg4.jpg'),
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(
          //   Colors.white.withOpacity(0.7),
          //   BlendMode.dstATop,
          // ),
        ),
      ),
    );
    // return Stack(
    //   children: [
    //     // Gradient 1: Radial
    //     Container(
    //       decoration: BoxDecoration(
    //         gradient: RadialGradient(
    //           center: const Alignment(0.0, 0.0),
    //           radius: 1.0,
    //           colors: [
    //             const Color.fromRGBO(235, 171, 245, 1),
    //             const Color.fromRGBO(255, 255, 255, 1),
    //           ],
    //           stops: const [0.0, 1.0],
    //         ),
    //       ),
    //     ),

    //     // Gradient 2: Linear
    //     Container(
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           begin: Alignment(-0.65, 0.6),
    //           end: Alignment(0.2, -0.3),
    //           colors: [
    //             const Color.fromRGBO(94, 133, 234, 1),
    //             const Color.fromRGBO(243, 164, 255, 0.5),
    //           ],
    //           stops: const [0.0, 1.0],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
