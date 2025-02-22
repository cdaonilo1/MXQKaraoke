import 'package:flutter/material.dart';

class NumericKeypad extends StatefulWidget {
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final int maxLength;
  final bool isLoading;
  final bool isSmall;
  final String placeholder;

  const NumericKeypad({
    Key? key,
    this.onSubmit,
    this.onChange,
    this.maxLength = 5,
    this.isLoading = false,
    this.isSmall = false,
    this.placeholder = 'Enter song code...',
  }) : super(key: key);

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  String _inputValue = '';

  void _handleNumberPress(String number) {
    if (_inputValue.length < widget.maxLength) {
      setState(() {
        _inputValue += number;
      });
      widget.onChange?.call(_inputValue);
    }
  }

  void _handleDelete() {
    if (_inputValue.isNotEmpty) {
      setState(() {
        _inputValue = _inputValue.substring(0, _inputValue.length - 1);
      });
      widget.onChange?.call(_inputValue);
    }
  }

  void _handleClear() {
    setState(() {
      _inputValue = '';
    });
    widget.onChange?.call('');
  }

  void _handleSubmit() {
    if (_inputValue.length == widget.maxLength) {
      widget.onSubmit?.call(_inputValue);
      setState(() {
        _inputValue = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    final buttonSize = widget.isSmall ? 40.0 : 60.0;

    return Container(
      width: widget.isSmall ? 300 : 400,
      padding: EdgeInsets.all(widget.isSmall ? 12 : 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border.all(color: Colors.grey[800]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Digital Display
          Container(
            height: widget.isSmall ? 48 : 96,
            margin: EdgeInsets.only(bottom: widget.isSmall ? 16 : 24),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => Text(
                  _inputValue.length > index ? _inputValue[index] : '0',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: widget.isSmall ? 24 : 48,
                    color: _inputValue.length > index
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),

          // Numeric Keypad
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            children: [
              ...numbers.take(9).map((num) => _buildButton(
                    text: num,
                    onPressed: () => _handleNumberPress(num),
                    size: buttonSize,
                  )),
              _buildButton(
                text: 'C',
                onPressed: _handleClear,
                color: Colors.red[500],
                size: buttonSize,
              ),
              _buildButton(
                text: '0',
                onPressed: () => _handleNumberPress('0'),
                size: buttonSize,
              ),
              _buildButton(
                text: '←',
                onPressed: _handleDelete,
                color: Colors.amber[500],
                size: buttonSize,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Enter Button
          SizedBox(
            width: double.infinity,
            height: widget.isSmall ? 48 : 64,
            child: ElevatedButton(
              onPressed: _inputValue.length == widget.maxLength && !widget.isLoading
                  ? _handleSubmit
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.blue[600]?.withOpacity(0.5),
              ),
              child: Text(
                widget.isLoading ? 'Loading...' : 'Enter',
                style: TextStyle(fontSize: widget.isSmall ? 16 : 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Color? color,
    required double size,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        onPressed: widget.isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: color ?? Colors.white,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: widget.isSmall ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
