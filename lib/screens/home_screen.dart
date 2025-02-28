import 'package:flutter/material.dart';
import 'package:tvbox_karaoke/widgets/info_bar.dart';
import 'package:tvbox_karaoke/widgets/numeric_keypad.dart';
import 'package:tvbox_karaoke/widgets/particle_background.dart';
import 'package:tvbox_karaoke/widgets/queue_display.dart';
import 'package:tvbox_karaoke/widgets/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int credits = 0;
  bool isPlaying = false;
  bool showSettings = false;
  bool showScore = false;
  Map<String, dynamic> currentScore = {
    'score': 0,
    'accuracy': 0,
    'message': '',
  };
  
  String? currentSongCode;
  String? currentSongTitle;
  String? currentSongArtist;
  String? currentVideoPath;
  String? currentFirstLyric;
  
  List<Map<String, dynamic>> songQueue = [];
  
  Map<String, dynamic> settings = {
    'credits': {
      'value': 1,
      'costPerSong': 1,
      'autoDeduct': true,
    },
    'playback': {
      'defaultVolume': 75,
      'autoplay': true,
      'videoQuality': 'high',
      'showNotes': true,
    },
    'storage': {
      'useExternalUSB': false,
      'dbPath': '/storage/emulated/0/KaraokeDB',
      'customBackground': '',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    // Adicionar listener para teclas
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }
  
  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }
  
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey.keyLabel == 'c') {
        setState(() {
          credits += settings['credits']['value'];
        });
      } else if (event.logicalKey.keyLabel == 'f') {
        setState(() {
          showSettings = true;
        });
      }
    }
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSettings = prefs.getString('settings');
    if (savedSettings != null) {
      // Implementar carregamento de configurações
    }
  }
  
  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Implementar salvamento de configurações
  }
  
  void _handleSongSubmit(String code, {bool addToQueue = false}) {
    if (credits < settings['credits']['costPerSong']) {
      // Mostrar mensagem de créditos insuficientes
      return;
    }
    
    // Simular busca de música
    final song = _mockSongLookup(code);
    if (song != null) {
      setState(() {
        credits -= settings['credits']['costPerSong'];
        
        if (addToQueue && currentSongCode != null) {
          songQueue.add(song);
        } else if (currentSongCode != null) {
          songQueue.insert(0, song);
        } else {
          currentSongCode = song['code'];
          currentSongTitle = song['title'];
          currentSongArtist = song['artist'];
          currentVideoPath = song['videoPath'];
          currentFirstLyric = song['firstLyric'];
          isPlaying = true;
        }
      });
    }
  }
  
  Map<String, dynamic>? _mockSongLookup(String code) {
    // Simular banco de dados
    return {
      'code': code,
      'title': 'Música $code',
      'artist': 'Artista $code',
      'videoPath': 'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4',
      'firstLyric': 'Primeira linha da letra da música $code...',
    };
  }
  
  void _handleVideoEnd() {
    // Gerar pontuação aleatória
    final score = 70 + (DateTime.now().millisecond % 30);
    String message = '';
    
    if (score >= 90) {
      message = 'Incrível! Você é uma estrela! 🌟';
    } else if (score >= 80) {
      message = 'Fantástico! Você arrasou! 🎉';
    } else if (score >= 70) {
      message = 'Muito bom! Continue assim! 🎵';
    } else if (score >= 60) {
      message = 'Boa performance! 👏';
    } else {
      message = 'Continue praticando! 💪';
    }
    
    setState(() {
      showScore = true;
      currentScore = {
        'score': score,
        'accuracy': 80 + (DateTime.now().millisecond % 20),
        'message': message,
      };
    });
    
    // Após 5 segundos, passar para próxima música
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showScore = false;
        
        if (songQueue.isNotEmpty) {
          final nextSong = songQueue.removeAt(0);
          currentSongCode = nextSong['code'];
          currentSongTitle = nextSong['title'];
          currentSongArtist = nextSong['artist'];
          currentVideoPath = nextSong['videoPath'];
          currentFirstLyric = nextSong['firstLyric'];
          isPlaying = true;
        } else {
          currentSongCode = null;
          currentSongTitle = null;
          currentSongArtist = null;
          currentVideoPath = null;
          currentFirstLyric = null;
          isPlaying = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com partículas
          const ParticleBackground(),
          
          // Versão e créditos
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              'v1.1',
              style: TextStyle(color: Colors.amber[600], fontSize: 14),
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
                  const Text(
                    '💰',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$credits',
                    style: TextStyle(
                      color: Colors.amber[600],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Teclado numérico centralizado
          if (currentSongCode == null)
            Center(
              child: NumericKeypad(
                onSubmit: (code) => _handleSongSubmit(code),
              ),
            ),
          
          // Player de vídeo
          if (currentSongCode != null && currentVideoPath != null)
            Column(
              children: [
                Expanded(
                  child: KaraokeVideoPlayer(
                    videoUrl: currentVideoPath!,
                    isPlaying: isPlaying,
                    onPlayPause: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    onEnded: _handleVideoEnd,
                  ),
                ),
                if (currentSongCode != null && currentSongTitle != null && 
                    currentSongArtist != null && currentFirstLyric != null)
                  InfoBar(
                    songCode: currentSongCode!,
                    title: currentSongTitle!,
                    artist: currentSongArtist!,
                    firstLyric: currentFirstLyric!,
                  ),
              ],
            ),
          
          // Teclado para fila
          if (currentSongCode != null)
            Positioned(
              bottom: 100,
              right: 16,
              child: SizedBox(
                width: 300,
                child: NumericKeypad(
                  size: NumericKeypadSize.small,
                  placeholder: 'Adicionar à fila...',
                  onSubmit: (code) => _handleSongSubmit(code, addToQueue: true),
                ),
              ),
            ),
          
          // Fila de músicas
          if (songQueue.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: QueueDisplay(
                queue: songQueue.map((song) => {
                  'id': song['code'],
                  'code': song['code'],
                  'title': song['title'],
                  'artist': song['artist'],
                }).toList(),
                onRemoveItem: (id) {
                  setState(() {
                    songQueue.removeWhere((song) => song['code'] == id);
                    credits += settings['credits']['costPerSong'];
                  });
                },
              ),
            ),
          
          // Mensagem de pontuação
          if (showScore)
            Center(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentScore['score'] >= 90 ? '🌟' :
                      currentScore['score'] >= 80 ? '🎉' :
                      currentScore['score'] >= 70 ? '🎵' :
                      currentScore['score'] >= 60 ? '👏' : '💪',
                      style: const TextStyle(fontSize: 72),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${currentScore['score']}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentScore['message'],
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Precisão: ${currentScore['accuracy']}%',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
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
