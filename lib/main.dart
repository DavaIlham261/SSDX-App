import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:ssdx_app/screens/app.dart';

void main() {
  runApp(const MyApp());

  // Atur ukuran dan tampilkan window
  doWhenWindowReady(() {
    final initialSize = Size(1440, 900); // ukuran tetap
    appWindow
    ..minSize = initialSize
    ..maxSize = initialSize
    ..size = initialSize
    ..alignment = Alignment.center
    ..title = "Custom Window App"
    ..show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}
