import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final String songCode;
  final String artist;
  final String title;
  final String firstLyric;

  const InfoBar({
    Key? key,
    this.songCode = '12345',
    this.artist = 'Unknown Artist',
    this.title = 'Untitled Song',
    this.firstLyric = 'First line of lyrics will appear here...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Row(
              children: [
                _buildInfoItem(
                  icon: Icons.code,
                  text: songCode,
                  isCode: true,
                ),
                const SizedBox(width: 24),
                _buildInfoItem(
                  icon: Icons.person,
                  text: artist,
                ),
                const SizedBox(width: 24),
                _buildInfoItem(
                  icon: Icons.music_note,
                  text: title,
                ),
              ],
            ),
            const SizedBox(width: 24),
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
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    bool isCode = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isCode ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
