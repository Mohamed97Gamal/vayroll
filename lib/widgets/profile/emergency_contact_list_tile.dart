import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';

class EmergencyContactListTile extends StatelessWidget {
  final EmergencyContact? emergencyContact;
  const EmergencyContactListTile({Key? key, this.emergencyContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (emergencyContact!.personName != null)
          Text(
            emergencyContact!.personName!,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
          ),
        if (emergencyContact!.personName != null) _divider(),
        if (emergencyContact!.phoneNumber != null)
          Text(
            emergencyContact!.phoneNumber!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        if (emergencyContact!.phoneNumber != null) _divider(),
        if (emergencyContact!.country != null)
          Text(
            emergencyContact!.country!.name!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        if (emergencyContact!.country != null) _divider(),
        if (emergencyContact!.address != null)
          Text(
            emergencyContact!.address!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        if (emergencyContact!.address != null) _divider(),
      ],
    );
  }

  Widget _divider() => Divider(
        thickness: 1,
        height: 1,
        color: DefaultThemeColors.whiteSmoke1,
      );
}
