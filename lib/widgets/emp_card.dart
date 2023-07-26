import 'dart:convert';
import 'package:vayroll/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';

class EmployeeCardWidget extends StatelessWidget {
  final Employee? employeeInfo;

  const EmployeeCardWidget({Key? key, this.employeeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final photoUInt8List = employeeInfo?.photoBase64;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 28.0,
              backgroundImage:
                  (photoUInt8List != null ? MemoryImage(base64Decode(photoUInt8List)) : AssetImage(VPayImages.avatar)) as ImageProvider<Object>?,
            ),
          ),
          title: Text(
            employeeInfo?.fullName ?? "",
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            "${context.appStrings!.employeeID} - ${employeeInfo?.employeeNumber ?? ""}",
            style: Theme.of(context).textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
