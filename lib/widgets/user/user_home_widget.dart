import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/theme/app_themes.dart';

class UserHomeWidget extends StatelessWidget {
  final String? name;
  final String? company;
  final String? imageBase64;
  final Function? onTap;

  const UserHomeWidget({Key? key, this.name, this.company, this.imageBase64, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name ?? "",
        maxLines: 1,
        style: Theme.of(context).textTheme.headline5,
      ),
      subtitle: Text(
        company ?? "",
        maxLines: 1,
        style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.brass),
      ),
      trailing: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: (imageBase64 != null ? MemoryImage(base64Decode(imageBase64!)) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
        ),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
