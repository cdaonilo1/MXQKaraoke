import 'package:flutter/material.dart';
import 'package:tvbox_karaoke/widgets/video_player.dart';
import 'package:tvbox_karaoke/widgets/numeric_keypad.dart';
import 'package:tvbox_karaoke/widgets/info_bar.dart';
import 'package:tvbox_karaoke/widgets/queue_display.dart';
import 'package:tvbox_karaoke/widgets/particle_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _credits = 0;
  bool _isPlaying = false;
  String? _typedSongCode;
  Map<String, dynamic>? _currentSong;
  List<QueueItem> _songQueue = [];
  bool _showNoCreditsMessage = false;

  void _handleSongSubmit(String code, {bool addToQueue = false}) {
    // Simulate credit check
    if (_credits < 1) {
      setState(() {
        _showNoCreditsMessage = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showNoCreditsMessage = false;
          });
        }
      });
      return;
    }

    // Simulate song lookup
    final song = {
      'code': code,
      'title': 'Test Song $code',
      'artist': 'Test Artist',
      'videoPath':
          'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4',
      'firstLyric': 'This is a test song',
    };

    setState(() {
      _credits--;

      if (addToQueue && _currentSong != null) {
        _songQueue.add(QueueItem(
          id: DateTime.now().toString(),
          code: song['code'],
          title: song['title'],
          artist: song['artist'],
        ));
      } else if (_currentSong != null) {
        _songQueue.insert(
          0,
          QueueItem(
            id: DateTime.now().toString(),
            code: song['code'],
            title: song['title'],
            artist: song['artist'],
          ),
        );
      } else {
        _currentSong = song;
        _isPlaying = true;
      }
    });
  }

  void _handleVideoEnd() {
    if (_songQueue.isNotEmpty) {
      setState(() {
        final nextSong = _songQueue.removeAt(0);
        _currentSong = {
          'code': nextSong.code,
          'title': nextSong.title,
          'artist': nextSong.artist,
          'videoPath':
              'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4',
          'firstLyric': 'This is the next song',
        };
        _isPlaying = true;
      });
    } else {
      setState(() {
        _currentSong = null;
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),

          // Version and Credits
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              'v1.1',
              style: TextStyle(color: Colors.amber[500], fontSize: 14),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '💰',
                    style: TextStyle(color: Colors.amber[500]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_credits',
                    style: TextStyle(
                      color: Colors.amber[500],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Centered Numeric Input
          if (_currentSong == null)
            Center(
              child: NumericKeypad(
                onSubmit: (code) => _handleSongSubmit(code),
                onChange: (value) {
                  setState(() {
                    _typedSongCode = value;
                  });
                },
              ),
            ),

          // Bottom Right Queue Input
          if (_currentSong != null)
            Positioned(
              bottom: 96,
              right: 16,
              child: NumericKeypad(
                isSmall: true,
                onSubmit: (code) => _handleSongSubmit(code, addToQueue: true),
                placeholder: 'Add to queue...',
              ),
            ),

          // Queue Display
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: QueueDisplay(
              queue: _songQueue,
              onRemoveItem: (id) {
                setState(() {
                  _songQueue.removeWhere((item) => item.id == id);
                  _credits++;
                });
              },
            ),
          ),

          // Video Player and Info Bar
          if (_currentSong != null) ...[            
            Positioned.fill(
              child: KaraokeVideoPlayer(
                videoUrl: _currentSong!['videoPath'],
                isPlaying: _isPlaying,
                onPlayPause: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                onEnded: _handleVideoEnd,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InfoBar(
                songCode: _currentSong!['code'],
                artist: _currentSong!['artist'],
                title: _currentSong!['title'],
                firstLyric: _currentSong!['firstLyric'],
              ),
            ),
          ],

          // No Credits Message
          if (_showNoCreditsMessage)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[500]?.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[600]!),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Insufficient Credits',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please add credits to play songs (Press 'C' to add credits)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
