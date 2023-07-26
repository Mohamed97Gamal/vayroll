import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/inner_text_form_field.dart';

class DatePickerWidget extends StatelessWidget {
  final String? hint;
  final TextStyle? textStyle;
  final DateTime? date;
  final Function? onChange;
  final String? Function(String?)? validator;

  const DatePickerWidget({Key? key, this.hint, this.date, this.onChange, this.textStyle, this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 30, maxHeight: 70),
      child: InnerTextFormField(
        controller: TextEditingController(
          text: date?.toString().isNotEmpty == true ? dateFormat.format(date!) : null,
        ),
        hintText: hint,
        readOnly: true,
        textStyle: textStyle,
        suffixIcon: SvgPicture.asset(
          VPayIcons.calendar,
          fit: BoxFit.none,
          alignment: Alignment.center,
        ),
        validator: validator ?? ((value) => value?.isEmpty??false ? context.appStrings!.requiredField : null),
        onTap: onChange as void Function()?,
      ),
    );
  }
}
