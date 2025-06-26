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
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: false,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey[600],
                ),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: (widget.height ?? 65 - 20) / 2,
        ),
      ),
    );
  }
}
