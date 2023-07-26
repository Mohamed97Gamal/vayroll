import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

Future<Attachment?> pickFile(
  BuildContext context, {
  FileType fileType = FileType.custom,
  List<String>? allowedExtensions,
}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: fileType, allowedExtensions: allowedExtensions);

  if (result == null) return null;

  if (fileType == FileType.custom && !allowedExtensions!.contains(result.files.single.extension!.toLowerCase())) {
    await showCustomModalBottomSheet(
      context: context,
      desc: context.appStrings!.unsupportedFileType,
    );
    return null;
  }

  if (result.files.single.size > 10000000) {
    await showCustomModalBottomSheet(
      context: context,
      desc: context.appStrings!.supportedFileSizeUpToTenMB,
    );
    return null;
  }

  File file = File(result.files.single.path!);
  return Attachment(
    name: result.files.single.name,
    extension: result.files.single.extension!.toLowerCase(),
    size: result.files.single.size,
    content: base64Encode(file.readAsBytesSync()),
  );
}
