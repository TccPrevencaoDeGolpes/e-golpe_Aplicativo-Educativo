import 'package:flutter/material.dart';

enum ButtonTipo { primary, neutral, alert, success, danger }

class ButtonCustom extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonTipo variant;

  const ButtonCustom({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonTipo.primary,
  });

  // Mapeamento de cores 
  Color get _backgroundColor {
    switch (variant) {
      case ButtonTipo.primary:
        return const Color(0xFF1E3A8A);
      case ButtonTipo.neutral:
        return const Color(0xFFF1F5F9);
      case ButtonTipo.alert:
        return const Color(0xFFF59E0B);
      case ButtonTipo.success:
        return const Color(0xFF15803D);
      case ButtonTipo.danger:
        return const Color(0xFF991B1B);
    }
  }

  Color get _shadowColor {
    switch (variant) {
      case ButtonTipo.primary:
        return const Color(0xFF0F2460);
      case ButtonTipo.neutral:
        return const Color(0xFF94A3B8);
      case ButtonTipo.alert:
        return const Color(0xFFB45309);
      case ButtonTipo.success:
        return const Color(0xFF14532D);
      case ButtonTipo.danger:
        return const Color(0xFF7F1D1D);
    }
  }

  Color get _textColor {
    switch (variant) {
      case ButtonTipo.neutral:
        return const Color(0xFF1E3A8A);
      case ButtonTipo.alert:
        return const Color(0xFF1A1A1A);
      default:
        return Colors.white;
    }
  }

  Color? get _borderColor {
    if (variant == ButtonTipo.neutral) {
      return const Color(0xFFCBD5E1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 56,
      ),
      width: double.infinity, 
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: _borderColor != null ? Border.all(color: _borderColor!, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            offset: const Offset(0, 4), // Efeito de sombra inferior
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5, 
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}