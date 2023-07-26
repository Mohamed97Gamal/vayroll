import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class InnerDropdownFormField<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final Widget? icon;
  final Function(T?)? onChanged;
  final Function(T?)? onSaved;
  final bool isDense;
  final Function(T?)? validator;

  const InnerDropdownFormField({
    Key? key,
    this.label,
    this.items,
    this.value,
    this.onChanged,
    this.onSaved,
    this.isDense = true,
    this.hint,
    this.icon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if ((label ?? "").isNotEmpty)
          Text(label!, style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<T>(
                hint: Text(hint ?? "",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.gainsboro)),
                value: value,
                items: items,
                icon: icon ??
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor,
                    ),
                validator: validator as String? Function(T?)?,
                onChanged: onChanged,
                onSaved: onSaved,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  isDense: isDense,
                  contentPadding: EdgeInsets.only(bottom: 8),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DefaultThemeColors.nepal),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                  errorMaxLines: 3,
                  errorStyle: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
