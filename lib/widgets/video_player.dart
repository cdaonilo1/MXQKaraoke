import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KaraokeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Function()? onNext;
  final Function()? onPrevious;
  final Function()? onPlayPause;
  final bool isPlaying;
  final Function()? onEnded;

  const KaraokeVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.onNext,
    this.onPrevious,
    this.onPlayPause,
    this.isPlaying = false,
    this.onEnded,
  }) : super(key: key);

  @override
  State<KaraokeVideoPlayer> createState() => _KaraokeVideoPlayerState();
}

class _KaraokeVideoPlayerState extends State<KaraokeVideoPlayer> {
  late VideoPlayerController _controller;
  double _volume = 0.75;
  double _pitch = 0;
  bool _isMuted = false;

  final List<String> notes = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        if (widget.isPlaying) {
          _controller.play();
        }
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        widget.onEnded?.call();
      }
    });
  }

  String _getCurrentNote() {
    final noteIndex = ((_pitch % 12) + 12) % 12;
    return notes[noteIndex.toInt()];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.95),
      child: Column(
        children: [
          // Video Display Area
          Expanded(
            child: Container(
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),

          // Controls Bar
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Playback Controls
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: widget.onPrevious,
                          color: Colors.white,
                        ),
                        IconButton(
                          icon: Icon(
                            widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: widget.onPlayPause,
                          color: Colors.white,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: widget.onNext,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    // Volume Control
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(_isMuted
                              ? Icons.volume_off
                              : Icons.volume_up),
                          onPressed: () {
                            setState(() {
                              _isMuted = !_isMuted;
                              _controller.setVolume(_isMuted ? 0 : _volume);
                            });
                          },
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 100,
                          child: Slider(
                            value: _volume,
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                                if (!_isMuted) {
                                  _controller.setVolume(_volume);
                                }
                              });
                            },
                            min: 0,
                            max: 1,
                          ),
                        ),
                      ],
                    ),

                    // Pitch Control
                    Row(
                      children: [
                        const Icon(Icons.music_note, color: Colors.white),
                        SizedBox(
                          width: 100,
                          child: Slider(
                            value: _pitch,
                            onChanged: (value) {
                              setState(() {
                                _pitch = value;
                                // Implement pitch shifting logic here
                              });
                            },
                            min: -12,
                            max: 12,
                            divisions: 24,
                          ),
                        ),
                      ],
                    ),

                    // Pitch Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        border: Border.all(
                            color: Colors.amber.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${_getCurrentNote()} (${_pitch >= 0 ? '+' : ''}${_pitch.toInt()})',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '(Press T to change)',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              opacity: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
