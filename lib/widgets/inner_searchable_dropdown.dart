import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/theme/app_themes.dart';

class InnerSearchableDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<T>? items;
  final T? value;
  final Widget? dropdownIcon;
  final Widget? clearIcon;
  final Function(T?)? onChanged;
  final Function(T?)? onSaved;
  final Function(T?)? validator;
  final String? Function(T)? itemAsString;
  final bool Function(T, String)? filterFunction;
  final bool isDense;
  final bool showSearchBox;
  final bool showClearButton;

  const InnerSearchableDropdown({
    Key? key,
    this.label,
    this.items,
    this.value,
    this.onChanged,
    this.onSaved,
    this.filterFunction,
    this.hint,
    this.dropdownIcon,
    this.clearIcon,
    this.validator,
    this.isDense = true,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.itemAsString,
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
              child: DropdownSearch<T>(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.gainsboro),
                    hintText: hint??"",

                    isDense: isDense,
                    contentPadding: EdgeInsets.zero,
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
                dropdownBuilder: (context,T){
                  if(T==null)
                    {return Container();}
                  else
                    return Container();
                },
                clearButtonProps: ClearButtonProps(
                  icon: dropdownIcon ?? Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                ),

                selectedItem: value,
                popupProps: PopupProps.bottomSheet(),

                items: items!,

                validator: validator as String? Function(T?)?,
                onChanged: onChanged,
                onSaved: onSaved,
                filterFn: filterFunction,
                itemAsString: itemAsString as String Function(T)?,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
