import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vayroll/utils/utils.dart';

class CommonTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onchanged;
  final FormFieldSetter<String>? onSubmit;
  final Function()? onTap;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? initialValue;
  final String? errorText;
  final InputBorder? border;
  final FocusNode? focusnode;
  final bool readonly;
  final bool? showcursor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool filled;
  final InputBorder? enabledBorder;
  final List<TextInputFormatter>? inputFormatters;
  final Key? key;
  final InputBorder? focusedBorder;
  final Color? cursorColor;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry contentPadding;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyle,
      key: key,
      cursorColor: cursorColor,
      onChanged: onchanged,
      showCursor: showcursor,
      inputFormatters: inputFormatters,
      readOnly: readonly,
      focusNode: focusnode,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      initialValue: initialValue,
      onFieldSubmitted: onSubmit,
      textInputAction: textInputAction,
      onTap: onTap,
      textAlignVertical: TextAlignVertical.bottom,
      textAlign: textAlign,
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: focusedBorder,
        focusColor: Colors.white,
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: filled,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: label,
        labelStyle: labelStyle,
        errorText: errorText,
        errorMaxLines: 3,
        errorStyle: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.20),
        border: border,
        enabledBorder: enabledBorder,
      ),
    );
  }

  CommonTextField({
    this.label,
    this.hintText,
    this.validator,
    this.onSaved,
    this.focusedBorder,
    this.onchanged,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.initialValue,
    this.errorText,
    this.border,
    this.focusnode,
    this.readonly = false,
    this.showcursor,
    this.fillColor,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.onSubmit,
    this.key,
    this.filled = true,
    this.enabledBorder,
    this.inputFormatters,
    this.cursorColor,
    this.textInputAction,
    this.contentPadding = const EdgeInsets.all(12),
    this.onTap,
    this.textAlign = TextAlign.start,
  });
}

class RequiredTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onchanged;
  final FormFieldSetter<String>? onSubmit;
  final String? missingMessage;
  final bool obscureText;
  final TextEditingController? controller;
  final String? initialValue;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? errorText;
  final InputBorder? border;
  final FocusNode? focusnode;
  final bool readonly;
  final bool? showcursor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool filled;
  final InputBorder? enabledBorder;
  final List<TextInputFormatter>? inputFormatters;
  final Key? key;
  final InputBorder? focusedBorder;
  final Color? cursorColor;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      showcursor: showcursor,
      readonly: readonly,
      label: label,
      key: key,
      hintText: hintText,
      focusnode: focusnode,
      onSaved: onSaved,
      onchanged: onchanged,
      onSubmit: onSubmit,
      validator: (value) => value?.isEmpty ?? false ? missingMessage ?? context.appStrings!.requiredField : null,
      controller: controller,
      obscureText: obscureText,
      initialValue: initialValue,
      maxLines: maxLines,
      prefixIcon: prefixIcon,
      keyboardType: keyboardType,
      errorText: errorText,
      border: border,
      labelStyle: labelStyle,
      suffixIcon: suffixIcon,
      textStyle: textStyle,
      fillColor: fillColor,
      hintStyle: hintStyle,
      filled: filled,
      enabledBorder: enabledBorder,
      inputFormatters: inputFormatters,
      focusedBorder: focusedBorder,
      cursorColor: cursorColor,
      textInputAction: textInputAction,
    );
  }

  RequiredTextField({
    this.label,
    this.hintText,
    this.onSaved,
    this.missingMessage,
    this.controller,
    this.obscureText = false,
    this.initialValue,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.errorText,
    this.border,
    this.focusnode,
    this.readonly = false,
    this.showcursor,
    this.fillColor,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.filled = true,
    this.enabledBorder,
    this.onchanged,
    this.onSubmit,
    this.key,
    this.inputFormatters,
    this.focusedBorder,
    this.cursorColor,
    this.textInputAction,
  });
}
