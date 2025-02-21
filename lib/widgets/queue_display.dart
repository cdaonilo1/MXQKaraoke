import 'package:flutter/material.dart';

class QueueDisplay extends StatelessWidget {
  final List<Map<String, String>> queue;
  final Function(int) onRemove;

  const QueueDisplay({
    super.key,
    required this.queue,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.black87,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.amber.withOpacity(0.3),
              ),
            ),
            child: const Text(
              'Próximas:',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: queue.length,
              itemBuilder: (context, index) {
                final song = queue[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey.shade700.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${index + 1}.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song['title'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            song['artist'] ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: () => onRemove(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}