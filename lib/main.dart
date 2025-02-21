import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const KaraokeApp());
}

class KaraokeApp extends StatelessWidget {
  const KaraokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Box Karaoke',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A2942),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}