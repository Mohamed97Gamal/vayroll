import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/models/models.dart';

class LeaveBalanceCardWidget extends StatelessWidget {
  final LeaveBalanceResponseDTO? leaveBalanceInfo;
  final bool showDetails;

  const LeaveBalanceCardWidget({
    Key? key,
    this.leaveBalanceInfo,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                constraints: BoxConstraints(maxHeight: 28, maxWidth: 100),
                child: Text(leaveBalanceInfo?.leaveRuleName ?? "",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, height: 1)),
              ),
            ),
            if (leaveBalanceInfo!.yourTotalBalance == leaveBalanceInfo!.maxNegativeBalanceMinus ||
                leaveBalanceInfo!.yourBalance == leaveBalanceInfo!.maxNegativeBalanceMinus )
              Expanded(
                flex: 4,
                child: FittedBox(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          VPayIcons.info,
                          height: 20.0,
                          width: 20.0,
                          fit: BoxFit.scaleDown,
                          color: Color(0xFF99B1C3),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          "You already consumed your ${leaveBalanceInfo!.leaveRuleName} Balance",
                          style: TextStyle(color: Color(0xFF99B1C3)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (leaveBalanceInfo!.yourTotalBalance > leaveBalanceInfo!.maxNegativeBalanceMinus &&
                leaveBalanceInfo!.yourBalance > leaveBalanceInfo!.maxNegativeBalanceMinus || (leaveBalanceInfo!.yourTotalBalance >0 &&
                leaveBalanceInfo!.yourBalance < 0))
              Expanded(
                flex: 4,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: leaveBalanceInfo!.yourBalance.toInt() != leaveBalanceInfo!.yourBalance
                            ? "${leaveBalanceInfo!.yourBalance}"
                            : "${leaveBalanceInfo!.yourBalance.toInt()}",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontSize: 30, color: Theme.of(context).colorScheme.secondary),
                      ),
                      TextSpan(
                        text: "/${leaveBalanceInfo!.yourTotalBalance?.toInt()}",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF99B1C3),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            Visibility(
              visible: showDetails,
              child: Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Show Balance details",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 9, fontFamily: Fonts.montserrat),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset(VPayIcons.leftArrow)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
