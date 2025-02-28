import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KaraokeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onEnded;

  const KaraokeVideoPlayer({
    super.key,
    required this.videoUrl,
    this.isPlaying = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onEnded,
  });

  @override
  State<KaraokeVideoPlayer> createState() => _KaraokeVideoPlayerState();
}

class _KaraokeVideoPlayerState extends State<KaraokeVideoPlayer> {
  late VideoPlayerController _controller;
  double _volume = 75;
  double _pitch = 0;
  bool _isMuted = false;
  final List<String> _notes = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(KaraokeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _initializeVideoPlayer();
    }
    
    if (oldWidget.isPlaying != widget.isPlaying) {
      widget.isPlaying ? _controller.play() : _controller.pause();
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        if (widget.isPlaying) {
          _controller.play();
        }
        _controller.setVolume(_volume / 100);
        _controller.setLooping(false);
      });
      
    _controller.addListener(() {
      if (_controller.value.isInitialized && 
          _controller.value.position >= _controller.value.duration) {
        widget.onEnded?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getCurrentNote() {
    final noteIndex = ((_pitch % 12) + 12) % 12;
    return _notes[noteIndex.toInt()];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Área do vídeo
        Expanded(
          child: Container(
            color: Colors.black,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
        
        // Controles
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.grey[900],
          child: Row(
            children: [
              // Controles de reprodução
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: widget.onPrevious,
                    tooltip: 'Música anterior',
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: widget.onPlayPause,
                    tooltip: widget.isPlaying ? 'Pausar' : 'Reproduzir',
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: widget.onNext,
                    tooltip: 'Próxima música',
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              
              // Controle de volume
              Row(
                children: [
                  IconButton(
                    icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                    onPressed: () {
                      setState(() {
                        _isMuted = !_isMuted;
                        _controller.setVolume(_isMuted ? 0 : _volume / 100);
                      });
                    },
                    tooltip: _isMuted ? 'Ativar som' : 'Silenciar',
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _volume,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          _volume = value;
                          _controller.setVolume(_isMuted ? 0 : _volume / 100);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              
              // Controle de tom
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _pitch,
                      min: -12,
                      max: 12,
                      divisions: 24,
                      onChanged: (value) {
                        setState(() {
                          _pitch = value;
                          // Implementação real de mudança de tom seria feita aqui
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Exibição do tom atual
              Row(
                children: [
                  const Text(
                    'Tom:',
                    style: TextStyle(color: Colors.amber, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${_getCurrentNote()} (${_pitch >= 0 ? "+${_pitch.toInt()}" : _pitch.toInt()})',
                      style: const TextStyle(color: Colors.amber, fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(Pressione T para mudar)',
                    style: TextStyle(color: Colors.amber.withOpacity(0.7), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
