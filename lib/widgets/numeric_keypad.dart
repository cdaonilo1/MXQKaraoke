import 'package:flutter/material.dart';

class NumericKeypad extends StatefulWidget {
  final Function(String) onSubmit;

  const NumericKeypad({
    super.key,
    required this.onSubmit,
  });

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  String input = '';
  final int maxLength = 5;

  void _addDigit(String digit) {
    if (input.length < maxLength) {
      setState(() {
        input += digit;
      });
    }
  }

  void _deleteDigit() {
    if (input.isNotEmpty) {
      setState(() {
        input = input.substring(0, input.length - 1);
      });
    }
  }

  void _clear() {
    setState(() {
      input = '';
    });
  }

  void _submit() {
    if (input.length == maxLength) {
      widget.onSubmit(input);
      _clear();
    }
  }

  Widget _buildButton(
    String text, {
    Color? textColor,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: MaterialButton(
          onPressed: onPressed,
          color: Colors.black54,
          height: 60,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Digital display
          Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade700,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(maxLength, (index) {
                final digit = index < input.length ? input[index] : '0';
                return Text(
                  digit,
                  style: TextStyle(
                    color: Colors.white.withOpacity(
                      index < input.length ? 1 : 0.3,
                    ),
                    fontSize: 40,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),

          // Number pad
          for (int row = 0; row < 4; row++)
            Row(
              children: [
                if (row < 3)
                  for (int col = 0; col < 3; col++)
                    _buildButton(
                      '${row * 3 + col + 1}',
                      onPressed: () => _addDigit('${row * 3 + col + 1}'),
                    )
                else ...[
                  _buildButton(
                    'C',
                    textColor: Colors.red,
                    onPressed: _clear,
                  ),
                  _buildButton(
                    '0',
                    onPressed: () => _addDigit('0'),
                  ),
                  _buildButton(
                    '←',
                    textColor: Colors.amber,
                    onPressed: _deleteDigit,
                  ),
                ],
              ],
            ),

          // Enter button
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: MaterialButton(
              onPressed: input.length == maxLength ? _submit : null,
              color: Colors.blue,
              disabledColor: Colors.blue.withOpacity(0.3),
              child: const Text(
                'Enter',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}