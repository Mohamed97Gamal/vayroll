import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/widgets/inner_dropdown_form_field.dart';
import 'package:vayroll/widgets/inner_text_form_field.dart';
import 'package:vayroll/utils/utils.dart';

class EmergencyContactRequestListTile extends StatelessWidget {
  final String? name;
  final String? number;
  final Country? country;
  final String? address;
  final Function(String?)? onNameSaved;
  final Function(String?)? onNameChanged;
  final Function(String?)? onNumberSaved;
  final Function(String?)? onNumberChanged;
  final Function(Country?)? onCountryChanged;
  final Function(String?)? onAddressSaved;
  final Function(String?)? onAddressChanged;
  final List<Country>? countries;
  final Function? onDelete;
  const EmergencyContactRequestListTile({
    this.name,
    this.number,
    this.country,
    this.address,
    this.onNameSaved,
    this.onNameChanged,
    this.onNumberSaved,
    this.onNumberChanged,
    this.onCountryChanged,
    this.onAddressSaved,
    this.onAddressChanged,
    this.countries,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                InnerTextFormField(
                  hintText: context.appStrings!.name,
                  initialValue: name,
                  validator: (value) {
                    if (value?.trim().isEmpty ?? false) return context.appStrings!.requiredField;
                    if (value!.trim().length > 200) return context.appStrings!.nameMustBeOneToTwoHundredCharacters;
                    return null;
                  },
                  onChanged: onNameChanged,
                  onSaved: onNameSaved,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                InnerTextFormField(
                  hintText: context.appStrings!.contactNumber,
                  initialValue: number,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s|-|\.|,|#|\*|N| |;|/|\(|\)"))],
                  validator: (value) {
                    if (value?.isEmpty ?? true) return context.appStrings!.requiredField;
                    if (value!.length < 5 || value.length > 20) return context.appStrings!.numberValidation;
                    return null;
                  },
                  onSaved: onNumberSaved,
                  onChanged: onNumberChanged,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                InnerDropdownFormField<Country>(
                  hint: context.appStrings!.country,
                  items: countries != null
                      ? countries!
                          .map((value) => DropdownMenuItem<Country>(value: value, child: Text(value.name!)))
                          .toList()
                      : null,
                  validator: (value) => value == null ? context.appStrings!.requiredField : null,
                  onChanged: onCountryChanged,
                  value: country,
                ),
                const SizedBox(height: 8),
                InnerTextFormField(
                  hintText: context.appStrings!.address,
                  initialValue: address,
                  maxLines: 3,
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) return context.appStrings!.requiredField;
                    if (value!.trim().length > 200) return context.appStrings!.addressValidation;
                    return null;
                  },
                  onSaved: onAddressSaved,
                  onChanged: onAddressChanged,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        FloatingActionButton(
          elevation: 0,
          mini: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(Icons.delete_forever, size: 20, color: Colors.white),
          onPressed: onDelete as void Function()?,
        ),
      ],
    );
  }
}
