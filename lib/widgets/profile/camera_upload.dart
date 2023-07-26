import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/theme/app_themes.dart';

class CameraUploadWidget extends StatelessWidget {
  final Function? uploadFile;
  final String? description;
  const CameraUploadWidget({Key? key, this.uploadFile, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: DefaultThemeColors.whiteSmoke3),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(VPayIcons.camera),
            SizedBox(height: 8),
            Text(description ?? "JPG, PNG or PDF, Smaller than 10mb",
                style: Theme.of(context).textTheme.caption!.copyWith(color: DefaultThemeColors.nepal)),
            SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: CustomElevatedButton(
                text: "Upload File".toUpperCase(),
                onPressed: uploadFile as void Function()?,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
