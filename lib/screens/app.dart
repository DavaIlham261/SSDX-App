import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:ssdx_app/models/game.dart';
import 'package:ssdx_app/screens/content.dart';
import 'package:ssdx_app/screens/side_menu.dart';
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
    final newGame = Game(
      name: 'New Game ${_games.length + 1}',
      developer: 'MiHoYo',
      genre: 'Action',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras consectetur neque id neque aliquam, at blandit elit interdum. Nullam libero diam, consequat sed vestibulum nec, semper vitae justo. Maecenas dictum arcu vel justo fermentum tempus. Praesent blandit ut lectus eget tempus. Duis ullamcorper non justo ac tristique. Curabitur facilisis tortor ac faucibus pulvinar. Nunc molestie sed urna ut finibus. Mauris efficitur eget massa sit amet tempor. Cras neque leo, finibus vel tincidunt nec, efficitur suscipit sapien. Aliquam vel metus nec lorem vehicula molestie. Suspendisse mattis leo congue lorem fringilla, et molestie urna consectetur.',
      releaseYear: '2020',
      size: '120',
      exePath: 'E:/Game/osu!/osu!.exe',
      folderPath: 'E:/Game/osu!/osu!.exe',
    );

    setState(() {
      _games.add(newGame);
      _filteredGames = List.from(_games);
    });
    await GameRepository.saveGame(_games);
  }

  Future<void> _deleteGame(Game game) async {
    _games.removeWhere((g) => g.name == game.name);
    await GameRepository.saveGame(_games);
    setState(() {
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
          color: Colors.black,
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
    return Stack(
      children: [
        // Gradient 1: Radial
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, 0.0),
              radius: 1.0,
              colors: [
                const Color.fromRGBO(235, 171, 245, 1),
                const Color.fromRGBO(255, 255, 255, 1),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),

        // Gradient 2: Linear
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.65, 0.6),
              end: Alignment(0.2, -0.3),
              colors: [
                const Color.fromRGBO(94, 133, 234, 1),
                const Color.fromRGBO(243, 164, 255, 0.5),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
