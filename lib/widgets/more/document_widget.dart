import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/utils/common.dart';

class DocumentCradWidget extends StatelessWidget {
  final Document? document;

  const DocumentCradWidget({Key? key, this.document}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: SvgPicture.asset(getDecomentIcon(document?.attachment?.extension?.toLowerCase())),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 100, maxHeight: 20),
                child: Text(
                  document?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
