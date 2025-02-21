import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final String code;
  final String title;
  final String artist;

  const InfoBar({
    super.key,
    required this.code,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.black,
      child: Row(
        children: [
          _buildSection(
            label: 'CÓDIGO',
            value: code,
            showBorder: true,
          ),
          _buildSection(
            label: 'CANTOR:',
            value: artist,
            showBorder: true,
          ),
          _buildSection(
            label: 'MUSICA:',
            value: title,
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String label,
    required String value,
    required bool showBorder,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(
                  right: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}