import 'package:flutter/material.dart';
import 'package:ssdx_app/widgets/glass_side_bar.dart';
import '../models/game.dart';

// Side menu widget
class SideMenu extends StatefulWidget {
  final Function(Game) onGameSelected;
  final Function() onAddGame;

  final Game? selectedGame;
  final List<Game> filteredGames;
  final List<Game> games;

  const SideMenu({
    super.key,
    required this.onGameSelected,
    required this.onAddGame,
    required this.selectedGame,

    required this.filteredGames,
    required this.games,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final TextEditingController _searchController = TextEditingController();
  List<Game> _filteredGames = [];

  @override
  void initState() {
    super.initState();

    _filteredGames = List.from(widget.games);

    // _loadGames();
    _searchController.addListener(_filterGames);
  }

  // Future<void> _loadGames() async {
  //   final games = await GameRepository.loadGames();
  //   setState(() {
  //     _games = games;
  //     _filteredGames = List.from(games);
  //     _selectedGame = games.isNotEmpty ? games.first : null;
  //   });
  // }

  void _filterGames() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGames =
          widget.games
              .where((game) => game.name.toLowerCase().contains(query))
              .toList();
    });
  }


  void _selectGame(Game game) {
    setState(() {
      widget.onGameSelected(game);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 337,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.7),
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const NetworkImage('https://i.pinimg.com/736x/1f/99/f9/1f99f9dc6b1875fdce23f35e9081f58c.jpg'),
          // image: const AssetImage('assets/images/side_bg.jpg'),
          // image: const AssetImage('assets/images/side_bg2.jpg'),
          // image: const AssetImage('assets/images/side_bg3.png'),
          // image: const AssetImage('assets/images/side_bg4.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // title app
                  SizedBox(
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'SSDX App',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Jersey 25",
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Search game & add Game
                  Container(
                    height: 51,
                    decoration: BoxDecoration(
                      // color: const Color.fromRGBO(94, 133, 234, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 8),

                        // Search game
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.8),
                              borderRadius: BorderRadius.circular(24),
                              // color: const Color.fromRGBO(255, 255, 255, 1),
                              boxShadow: [
                                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1)),
                                BoxShadow(
                                  color: const Color.fromRGBO(250, 250, 250, 1),
                                  blurRadius: 5,
                                  spreadRadius: -2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _searchController,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(163, 163, 163, 1),
                                  fontFamily: 'Jersey 25',
                                ),
                                decoration: const InputDecoration.collapsed(
                                  hintText: "Search games",
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 8),

                        // Add Game
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(105, 127, 253, 1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color.fromRGBO(192, 192, 192, 1),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.2),
                                blurRadius: 5,
                                // spreadRadius: 1,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),

                          child: IconButton(
                            onPressed: widget.onAddGame(),
                            icon: Icon(
                              Icons.add,
                              size: 18,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),

                        SizedBox(width: 8),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  // Konten menu
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: const Color.fromRGBO(255, 255, 255, 0.7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: _filteredGames.length,
                        itemBuilder: (BuildContext context, int index) {
                          final game = _filteredGames[index];
                          final isSelected = game == widget.selectedGame;
                          return MenuItem(
                            game: game,
                            selected: isSelected,
                            onTap: () => _selectGame(game),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.7),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  final Game game;
  final bool selected;
  final VoidCallback onTap;
  const MenuItem({
    super.key,
    required this.game,
    this.selected = false,
    required this.onTap,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    // warna hover & selected
    final bgColor =
        widget.selected
            ? const Color.fromRGBO(255, 255, 255, .3)
            : Colors.black26;

    final boxShadow =
        widget.selected
            ? [
              BoxShadow(
                // color: const Color.fromRGBO(0, 0, 0, 0.5),
                color: const Color.fromRGBO(0, 0, 0, 0),
                blurRadius: 25,
                spreadRadius: -5,
              ),
            ]
            : _hovering
            ? [
              BoxShadow(color: const Color.fromRGBO(199, 105, 253, 0.7)),
              BoxShadow(
                color: Color.fromARGB(255, 249, 242, 255),
                blurRadius: 5,
                spreadRadius: -2,
              ),
            ]
            : null;

    final decoration = BoxDecoration(
      color: bgColor,
      boxShadow: boxShadow,
      borderRadius: BorderRadius.circular(30),
      border:
          widget.selected ? Border.all(color: Colors.white30, width: 2) : null,
      gradient:
          widget.selected
              ? LinearGradient(
                colors: [Colors.white60, Colors.white10],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
              : null,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            widget.selected
                ? GlassSidebar(
                  child: Column(
                    children: [
                      Container(
                        height: 33,
                        color: Colors.transparent,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.game.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Jersey 25",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.game.genre,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Jersey 25",
                                fontSize: 14,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Container(
                  height: 60,
                  decoration: decoration,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 60,

                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.game.name,
                        style: TextStyle(
                          fontFamily: "Jersey 25",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.selected
                                  ? Colors.black87
                                  : _hovering
                                  ? const Color.fromRGBO(105, 127, 253, 1)
                                  : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
