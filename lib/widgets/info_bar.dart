import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final String songCode;
  final String artist;
  final String title;
  final String firstLyric;

  const InfoBar({
    super.key,
    required this.songCode,
    required this.artist,
    required this.title,
    required this.firstLyric,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          // Código
          Row(
            children: [
              const Icon(Icons.code, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                songCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          
          // Artista
          Row(
            children: [
              const Icon(Icons.person, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                artist,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(width: 24),
          
          // Título
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          
          // Primeira linha da letra
          Expanded(
            child: Text(
              firstLyric,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
