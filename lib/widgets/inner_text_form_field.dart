import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vayroll/theme/app_themes.dart';

class InnerTextFormField extends StatelessWidget {
  final String? label;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final String obscuringCharacter;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;
  final FormFieldSetter<String>? onSaved;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final bool isDense;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const InnerTextFormField({
    Key? key,
    this.label,
    this.textStyle,
    this.inputFormatters,
    this.readOnly = false,
    this.focusNode,
    this.validator,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.controller,
    this.keyboardType,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onSaved,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.bottom,
    this.isDense = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((label ?? "").isNotEmpty)
          Text(label!, style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
        if ((label ?? "").isNotEmpty && suffixIcon == null) const SizedBox(height: 8),
        TextFormField(
          key: key,
          style: textStyle ?? Theme.of(context).textTheme.bodyText2,
          cursorColor: Theme.of(context).primaryColor,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          focusNode: focusNode,
          validator: validator,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          initialValue: initialValue,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onEditingComplete: onEditingComplete,
          onTap: onTap,
          onSaved: onSaved,
          textInputAction: textInputAction,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.gainsboro),
            isDense: isDense,
            focusColor: Colors.white,
            contentPadding: EdgeInsets.only(bottom: 8),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorMaxLines: 3,
            errorStyle: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.20),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DefaultThemeColors.nepal),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
      ],
    );
  }
}
