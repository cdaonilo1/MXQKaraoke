import 'package:flutter/material.dart';

enum NumericKeypadSize { normal, small }

class NumericKeypad extends StatefulWidget {
  final Function(String) onSubmit;
  final Function(String)? onChange;
  final int maxLength;
  final bool isLoading;
  final NumericKeypadSize size;
  final String placeholder;

  const NumericKeypad({
    super.key,
    required this.onSubmit,
    this.onChange,
    this.maxLength = 5,
    this.isLoading = false,
    this.size = NumericKeypadSize.normal,
    this.placeholder = 'Digite o código da música...',
  });

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  String inputValue = '';

  void _handleNumberClick(String number) {
    if (inputValue.length < widget.maxLength) {
      setState(() {
        inputValue += number;
      });
      widget.onChange?.call(inputValue);
    }
  }

  void _handleDelete() {
    if (inputValue.isNotEmpty) {
      setState(() {
        inputValue = inputValue.substring(0, inputValue.length - 1);
      });
      widget.onChange?.call(inputValue);
    }
  }

  void _handleClear() {
    setState(() {
      inputValue = '';
    });
    widget.onChange?.call(inputValue);
  }

  void _handleSubmit() {
    if (inputValue.length == widget.maxLength) {
      widget.onSubmit(inputValue);
      setState(() {
        inputValue = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = widget.size == NumericKeypadSize.small;
    final buttonSize = isSmall ? 40.0 : 60.0;
    final fontSize = isSmall ? 18.0 : 24.0;
    final width = isSmall ? 300.0 : 400.0;
    
    return Container(
      width: width,
      padding: EdgeInsets.all(isSmall ? 12 : 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display
          Container(
            height: isSmall ? 48 : 80,
            margin: EdgeInsets.only(bottom: isSmall ? 12 : 24),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  widget.maxLength,
                  (index) => Text(
                    index < inputValue.length ? inputValue[index] : '0',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: isSmall ? 24 : 36,
                      fontWeight: FontWeight.bold,
                      color: index < inputValue.length
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Keypad
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Numbers 1-9
              for (int i = 1; i <= 9; i++)
                _buildButton(
                  i.toString(),
                  () => _handleNumberClick(i.toString()),
                  buttonSize,
                  fontSize,
                ),
              
              // Clear button
              _buildButton(
                'C',
                _handleClear,
                buttonSize,
                fontSize,
                textColor: Colors.red,
              ),
              
              // Number 0
              _buildButton(
                '0',
                () => _handleNumberClick('0'),
                buttonSize,
                fontSize,
              ),
              
              // Delete button
              _buildButton(
                '←',
                _handleDelete,
                buttonSize,
                fontSize,
                textColor: Colors.amber,
              ),
            ],
          ),
          
          // Enter button
          SizedBox(height: isSmall ? 8 : 16),
          SizedBox(
            width: double.infinity,
            height: isSmall ? 48 : 64,
            child: ElevatedButton(
              onPressed: inputValue.length == widget.maxLength && !widget.isLoading
                  ? _handleSubmit
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.blue[800]!.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.isLoading ? 'Carregando...' : 'Entrar',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildButton(
    String text,
    VoidCallback onPressed,
    double size,
    double fontSize, {
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
