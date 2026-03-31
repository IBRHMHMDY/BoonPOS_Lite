import 'package:flutter/material.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final bool showClearButton;

  const CustomNumpad({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
    required this.onClear,
    this.showClearButton = true,
  });

 @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0), // تقليل الـ padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 8), // تقليل المسافات الرأسية
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 8),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                text: showClearButton ? 'C' : '.',
                color: showClearButton ? Colors.red.shade100 : Colors.grey.shade200,
                textColor: showClearButton ? Colors.red.shade700 : Colors.black87,
                onTap: showClearButton ? onClear : () => onKeyPress('.'),
              ),
              _buildButton(
                text: '0',
                color: Colors.grey.shade200,
                onTap: () => onKeyPress('0'),
              ),
              _buildButton(
                icon: Icons.backspace_outlined,
                color: Colors.orange.shade100,
                iconColor: Colors.orange.shade800,
                onTap: onBackspace,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return _buildButton(
          text: key,
          color: Colors.grey.shade200,
          onTap: () => onKeyPress(key),
        );
      }).toList(),
    );
  }

  Widget _buildButton({
    String? text,
    IconData? icon,
    required Color color,
    Color textColor = Colors.black87,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 70, // تم التقليل من 80 لتناسب وضع الـ Landscape
          height: 70, // تم التقليل من 80
          alignment: Alignment.center,
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor), // تصغير الخط قليلاً
                )
              : Icon(icon, size: 28, color: iconColor),
        ),
      ),
    );
  }
}