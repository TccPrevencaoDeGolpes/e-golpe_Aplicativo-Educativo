import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustom extends StatefulWidget {
  final String? label;
  final String? hintText;
  final IconData? icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool isPhone;

  const InputCustom({
    super.key,
    this.label,
    this.hintText,
    this.icon,
    required this.controller,
    this.isPassword = false,
    this.isPhone = false,
  });

  @override
  State<InputCustom> createState() => _InputCustomState();
}

class _InputCustomState extends State<InputCustom> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text,
      inputFormatters: widget.isPhone
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9()\-\s]'))]
          : null,
      onChanged: widget.isPhone
          ? (valor) {
              final numeros = valor.replaceAll(RegExp(r'[^0-9]'), '');

              String formatado;

              if (numeros.length <= 2) {
                formatado = numeros.isEmpty ? numeros : '($numeros';
              } else if (numeros.length <= 7) {
                formatado =
                    '(${numeros.substring(0, 2)}) ${numeros.substring(2)}';
              } else {
                formatado =
                    '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7, numeros.length > 11 ? 11 : numeros.length)}';
              }

              widget.controller.value = TextEditingValue(
                text: formatado,
                selection: TextSelection.collapsed(offset: formatado.length),
              );
            }
          : null,
      style: const TextStyle(fontSize: 18, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: const Color(0xFF64748B))
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF64748B),
                ),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
      ),
    );
  }
}
