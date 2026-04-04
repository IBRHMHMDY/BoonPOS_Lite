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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(), // ظل ناعم جداً
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(context, ['1', '2', '3']),
          const SizedBox(height: 8),
          _buildRow(context, ['4', '5', '6']),
          const SizedBox(height: 8),
          _buildRow(context, ['7', '8', '9']),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                context: context,
                text: showClearButton ? 'C' : '.',
                // استخدام لون الخطأ (الأحمر) بشفافية لزر الحذف الشامل
                color: showClearButton ? colorScheme.error.withValues() : Colors.grey.withValues(),
                textColor: showClearButton ? colorScheme.error : colorScheme.onSurface,
                onTap: showClearButton ? onClear : () => onKeyPress('.'),
              ),
              _buildButton(
                context: context,
                text: '0',
                color: Colors.grey.withValues(),
                onTap: () => onKeyPress('0'),
              ),
              _buildButton(
                context: context,
                icon: Icons.backspace_outlined,
                // استخدام اللون الأساسي (الأزرق) بشفافية لزر التراجع
                color: colorScheme.primary.withValues(),
                iconColor: colorScheme.primary,
                onTap: onBackspace,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return _buildButton(
          context: context,
          text: key,
          color: Colors.grey.withValues(), // رمادي فاتح مريح يتأقلم مع الثيم
          onTap: () => onKeyPress(key),
        );
      }).toList(),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    String? text,
    IconData? icon,
    required Color color,
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: text != null
              ? Text(
                  text,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor ?? theme.colorScheme.onSurface,
                  ),
                )
              : Icon(icon, size: 28, color: iconColor ?? theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}