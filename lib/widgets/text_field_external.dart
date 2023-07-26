import 'package:flutter/material.dart';

class TextFieldExternal extends StatelessWidget {
  final String? label;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? initialValue;
  final String? errorText;
  final FocusNode? focusNode;
  final bool readonly;
  final bool? showCursor;
  final Color fillColor;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: hintStyle ?? labelStyle,
      onChanged: onChanged,
      showCursor: showCursor,
      readOnly: readonly,
      focusNode: focusNode,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      initialValue: initialValue,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: filled,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: label,
        labelStyle: labelStyle,
        errorText: errorText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  TextFieldExternal({
    this.label,
    this.hintText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.initialValue,
    this.errorText,
    this.focusNode,
    this.readonly = false,
    this.showCursor,
    this.fillColor = const Color(0xFFEFF3F5),
    this.labelStyle,
    this.hintStyle,
    this.filled = true,
  });
}
