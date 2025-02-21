import 'package:flutter/material.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/info_bar.dart';
import '../widgets/queue_display.dart';
import '../widgets/video_player.dart';
import '../widgets/particle_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int credits = 0;
  String? currentCode;
  String? currentTitle;
  String? currentArtist;
  List<Map<String, String>> songQueue = [];

  void _handleSongSubmit(String code) {
    // TODO: Implement song lookup and queue management
    setState(() {
      currentCode = code;
      currentTitle = 'Song Title'; // Replace with actual song lookup
      currentArtist = 'Artist Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          
          // Version number
          const Positioned(
            top: 16,
            left: 16,
            child: Text(
              'v1.1',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 14,
              ),
            ),
          ),

          // Credits display
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    '💰',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$credits',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Centered numeric keypad
          Center(
            child: NumericKeypad(
              onSubmit: _handleSongSubmit,
            ),
          ),

          // Bottom info bar
          Positioned(
            bottom: songQueue.isEmpty ? 0 : 48,
            left: 0,
            right: 0,
            child: InfoBar(
              code: currentCode ?? '1234',
              title: currentTitle ?? 'Untitled Song',
              artist: currentArtist ?? 'Unknown Artist',
            ),
          ),

          // Queue display at bottom
          if (songQueue.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: QueueDisplay(
                queue: songQueue,
                onRemove: (index) {
                  setState(() {
                    songQueue.removeAt(index);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}