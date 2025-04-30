import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:ssdx_app/models/game.dart';
import 'package:ssdx_app/screens/window_control.dart';
import 'package:flutter/material.dart';
import 'package:ssdx_app/services/game_repository.dart';
import 'package:ssdx_app/widgets/circle_button.dart';
import 'package:ssdx_app/widgets/glass_side_bar.dart';

// Main content area with header and main content
class MainContent extends StatelessWidget {
  final Game? selectedGame;
  final Function(Game) onDeleteGame;

  const MainContent({
    super.key, 
    required this.selectedGame,
    required this.onDeleteGame,
    });

  @override
  Widget build(BuildContext context) {
    if (selectedGame == null) {
      return const Center(
        child: Text(
          'Pilih game untuk melihat detailnya.',
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return Column(
      children: [
        // Header
        SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.7),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 24,
                      right: 16,
                      bottom: 0,
                    ),
                    child: Header(selectedGame: selectedGame, onDeleteGame: onDeleteGame,),
                  ),
                ),
              ),

              // Tambahkan tombol close dan minimize kamu sendiri di pojok kanan atas
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Container(
                  width: 143,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(27),
                      topRight: Radius.circular(27),
                      bottomRight: Radius.circular(27),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: WindowControl(),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Konten utama
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            // Konten utama di sini
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 8,
                top: 8,
              ),
              child: Column(
                spacing: 8,
                children: [
                  // Image Holder
                  Expanded(
                    child: GlassSidebar(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(235, 171, 245, 0.6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dev & release
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          selectedGame!.developer,
                          style: TextStyle(fontSize: 17, fontFamily: "inter"),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(51, 45, 72, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          selectedGame!.releaseYear,
                          style: TextStyle(fontSize: 17, fontFamily: "inter"),
                        ),
                      ],
                    ),
                  ),

                  // Genre, Size, & Location
                  GlassSidebar(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        // color: const Color.fromRGBO(235, 171, 245, 0.6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 8,
                        children: [
                          Text(
                            selectedGame!.genre,
                            style: TextStyle(fontSize: 17, fontFamily: "inter"),
                          ),
                          Text(
                            selectedGame!.size,
                            style: TextStyle(fontSize: 17, fontFamily: "inter"),
                          ),

                          Text(
                            selectedGame!.folderPath,
                            style: TextStyle(fontSize: 17, fontFamily: "inter"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Deskripsi
                  Container(
                    width: double.infinity,
                    height: 241,
                    decoration: BoxDecoration(
                      // color: const Color.fromRGBO(235, 171, 245, 0.6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GlassSidebar(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'About',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "inter",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  selectedGame!.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "inter",
                                  ),
                                ),
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
          ),
        ),
      ],
    );
  }
}

class GameAction {
  static void playGame(Game game) {
    if (game.exePath.isEmpty) return;
    Process.start(game.exePath, []);
  }

  static void openGameFolder(Game game) {
    if (game.folderPath.isEmpty) return;
    Process.start('explorer', [game.folderPath]);
  }

  static void deleteGame(BuildContext context, Game game, List<Game> games) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Game'),
            content: Text('Apakah kamu yakin ingin menghapus "${game.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      games.removeWhere((g) => g.name == game.name);
      await GameRepository.saveGame(games);
    }
  }
}


class Header extends StatelessWidget {
  final Game? selectedGame;
  final Function(Game) onDeleteGame;

  const Header({
    super.key, 
    required this.selectedGame,
    required this.onDeleteGame,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Judul
          Expanded(
            child: MoveWindow(
              child: SizedBox(
                height: double.infinity,
                child: Text(
                  selectedGame!.name,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: "jersey 25",
                  ),
                ),
              ),
            ),
          ),

          // Tombol lainnya (misalnya, pengaturan)
          Container(
            width: 201,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(235, 171, 245, 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleButton(
                  iconData: Icons.play_arrow,
                  iconSize: 35,
                  buttonColor: const Color.fromRGBO(105, 127, 253, 1),
                  onPressed: () => GameAction.playGame(selectedGame!),
                ),
                CircleButton(
                  iconData: Icons.folder,
                  iconSize: 25,
                  buttonColor: Color.fromRGBO(26, 23, 30, 1),
                  onPressed: () => GameAction.openGameFolder(selectedGame!),
                ),
                CircleButton(
                  iconData: Icons.edit,
                  iconSize: 25,
                  buttonColor: Color.fromRGBO(26, 23, 30, 1),
                ),
                CircleButton(
                  iconData: Icons.delete,
                  iconSize: 27,
                  buttonColor: Color.fromRGBO(255, 0, 0, 1),
                  onPressed: () => onDeleteGame(selectedGame!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
