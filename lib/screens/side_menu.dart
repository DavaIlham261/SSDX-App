// ignore_for_file: deprecated_member_use, sized_box_for_whitespace

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

class _SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Game> _filteredGames = [];
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize title animation
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeOutBack,
    ));
    
    _titleAnimationController.forward();

    _filterGames();
    _searchController.addListener(_filterGames);
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SideMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.games != oldWidget.games) {
      _filterGames();
    }
  }

  void _filterGames() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGames = widget.games
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
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/side_bg2.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Enhanced title with animation
                    SizedBox(
                      height: 56,
                      child: AnimatedBuilder(
                        animation: _titleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _titleAnimation.value,
                            child: Opacity(
                              opacity: _titleAnimation.value.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [
                                        Color(0xFF667eea),
                                        Color(0xFF764ba2),
                                      ],
                                    ).createShader(bounds),
                                    child: const Text(
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
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Enhanced Search and Add Game section
                    Container(
                      height: 51,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          
                          // Enhanced Search field
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.9),
                                    Colors.white.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: -2,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: -3,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF4a5568),
                                    fontFamily: 'Jersey 25',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Search games",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.6),
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Enhanced Add Game button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF667eea),
                                  Color(0xFF764ba2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF667eea).withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: -2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: widget.onAddGame,
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Games list with staggered animation
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _filteredGames.length,
                          itemBuilder: (BuildContext context, int index) {
                            final game = _filteredGames[index];
                            final isSelected = game == widget.selectedGame;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300 + (index * 50)),
                              curve: Curves.easeOutBack,
                              child: MenuItem(
                                game: game,
                                selected: isSelected,
                                onTap: () => _selectGame(game),
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Enhanced bottom section
              Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  final Game game;
  final bool selected;
  final VoidCallback onTap;
  final int index;
  
  const MenuItem({
    super.key,
    required this.game,
    this.selected = false,
    required this.onTap,
    required this.index,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> with TickerProviderStateMixin {
  bool _hovering = false;
  late AnimationController _hoverController;
  late AnimationController _selectController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _selectController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    if (widget.selected) {
      _selectController.forward();
    }
  }

  @override
  void didUpdateWidget(MenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        _selectController.forward();
      } else {
        _selectController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovering = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _hovering = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverController, _selectController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Column(
                children: [
                  widget.selected
                      ? GlassSidebar(
                          blurSigma: 10,
                          height: 70,
                          glowIntensity: _glowAnimation.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    widget.game.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Jersey 25",
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      height: 2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.game.genre,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontFamily: "Jersey 25",
                                      fontSize: 14,
                                      height: 0.1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: _hovering
                                ? LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.15),
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: _hovering 
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: _hovering
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF667eea).withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: -2,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: -2,
                                      offset: const Offset(0, -2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.game.name,
                                style: TextStyle(
                                  fontFamily: "Jersey 25",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _hovering
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  shadows: _hovering
                                      ? [
                                          const Shadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}