import 'package:flutter/material.dart';

class QueueItem {
  final String id;
  final String code;
  final String title;
  final String artist;

  QueueItem({
    required this.id,
    required this.code,
    required this.title,
    required this.artist,
  });
}

class QueueDisplay extends StatelessWidget {
  final List<QueueItem> queue;
  final Function(String)? onRemoveItem;

  const QueueDisplay({
    Key? key,
    this.queue = const [],
    this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (queue.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[500]?.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.amber[500]!.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Próximas:',
                    style: TextStyle(
                      color: Colors.amber[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ...queue.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey[700]!.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.music_note,
                                size: 16,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                item.artist,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => onRemoveItem?.call(item.id),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[700]?.withOpacity(0.3),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
