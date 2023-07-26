import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class CertificateCard extends StatelessWidget {
  final CertificateResponseDTO? certificateInfo;
  final Function? deleteCertificate;
  final Function? updateCertificate;
  final Function? viewCertificate;

  const CertificateCard({
    Key? key,
    this.certificateInfo,
    this.deleteCertificate,
    this.updateCertificate,
    this.viewCertificate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime? fromDate = certificateInfo?.issueDate?.isNotEmpty == true
        ? DateFormat("yyyy").parse(certificateInfo!.issueDate!.split(" ")[0]!)
        : null;
    final DateTime? toDate = certificateInfo?.expiryDate?.isNotEmpty == true
        ? DateFormat("yyyy").parse(certificateInfo!.expiryDate!.split(" ")[0]!)
        : null;

    var subtitle = "${certificateInfo?.issuingOrganization} ";
    if (fromDate != null) {
      if (toDate != null) {
        if (certificateInfo?.hasExpiry ?? false) {
          subtitle += "(${DateFormat("yyyy").format(fromDate)}-${DateFormat("yyyy").format(toDate)})";
        } else {
          subtitle += "(${DateFormat("yyyy").format(fromDate)})";
        }
      } else {
        subtitle += "(${DateFormat("yyyy").format(fromDate)})";
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 16),
          title: Wrap(
            children: [
              Container(
                child: Text(
                  certificateInfo?.name ?? "",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        height: 1.20,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Wrap(
                children: [
                  Container(
                    child: Text(
                      subtitle,
                      style:
                          Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal, height: 1.20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (certificateInfo?.attachment?.id?.toString().isNotEmpty == true)
                InkWell(
                  onTap: viewCertificate as void Function()?,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 40, minHeight: 20),
                    child: Text(
                      context.appStrings!.viewCertificate,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                            height: 1.20,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
            ],
          ),
          trailing: certificateInfo!.hasDeleteRequest!
              ? SizedBox()
              : Container(
                  height: 20,
                  child: PopupMenuButton(
                    color: Theme.of(context).primaryColor,
                    iconSize: 30,
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).primaryColor,
                    ),
                    offset: Offset(-5, 15),
                    padding: EdgeInsets.zero,
                    shape: TooltipShape(),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(context.appStrings!.edit,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                          value: "Edit"),
                      PopupMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(context.appStrings!.delete,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                          value: "Delete"),
                    ],
                    onSelected: (dynamic value) {
                      if (value == "Edit")
                        updateCertificate!();
                      else
                        deleteCertificate!();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
