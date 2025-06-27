import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

// Window control buttons (close and minimize)
class WindowControl extends StatelessWidget {
  const WindowControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.minimize),
            style: IconButton.styleFrom(
              hoverColor: Colors.red.withOpacity(0.1),
              highlightColor: Colors.red.withOpacity(0.2)
            ),
            onPressed: () => appWindow.minimize(),
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.close),
            style: IconButton.styleFrom(
              hoverColor: Colors.red.withOpacity(0.1),
              highlightColor: Colors.red.withOpacity(0.2)
            ),
            onPressed: () => appWindow.close(),
          ),
        ],
      ),
    );
  }
}