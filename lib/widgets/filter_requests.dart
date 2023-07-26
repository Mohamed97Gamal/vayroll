import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/inner_dropdown_form_field.dart';
import 'package:vayroll/utils/utils.dart';

class FilterRequestsWidget extends StatefulWidget {
  final bool filterVisiable;
  final String? status;
  final Function(String? value)? onStatusChange;
  final Function? ontap;

  const FilterRequestsWidget({Key? key, this.filterVisiable = false, this.status, this.onStatusChange, this.ontap})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => FilterRequestsWidgetState();
}

class FilterRequestsWidgetState extends State<FilterRequestsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.filterVisiable!) ...[
              Expanded(
                flex: 9,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: InnerDropdownFormField<String>(
                    hint: context.appStrings!.selectStatus,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: ["All", "New", "Submitted"]
                        .map((status) => DropdownMenuItem<String>(value: status, child: Text(status)))
                        .toList(),
                    onChanged: widget.onStatusChange,
                    value: widget.status,
                  ),
                ),
              ),
            ],
            Spacer(),
            GestureDetector(
              onTap: widget.ontap as void Function()?,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.filterVisiable! ? DefaultThemeColors.lightCyan : Colors.transparent,
                ),
                child: SvgPicture.asset(
                  VPayIcons.filter,
                  fit: BoxFit.none,
                  alignment: Alignment.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
