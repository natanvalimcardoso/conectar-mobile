import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputWidget extends StatefulWidget {  
  final String hintText;
  final TextEditingController? controller;
  final bool isPasswordField;
  final TextInputType keyboardType;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final double? height;

  const CustomInputWidget({
    super.key,
    required this.hintText,
    this.controller,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.inputFormatters,
    this.onChanged,
    this.focusNode,
    this.validator,
    this.height,
  });

  @override
  State<CustomInputWidget> createState() => _CustomInputWidgetState();
}

class _CustomInputWidgetState extends State<CustomInputWidget> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordField && !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      validator: widget.validator,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF2E2E2E),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[600],
                  size: 22,
                ),
                splashRadius: 20,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: (widget.height ?? 56 - 16) / 2,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          color: Colors.red,
        ),
      ),
    );
  }
}
