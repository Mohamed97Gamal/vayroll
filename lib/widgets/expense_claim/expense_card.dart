import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';

class ExpenseHomeCard extends StatelessWidget {
  final Expenses? expenseInfo;
  final Employee? emp;

  const ExpenseHomeCard({Key? key, this.expenseInfo, this.emp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 40, minWidth: 160),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  expenseInfo?.name ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 15, color: Colors.white, height: 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    expenseInfo?.percentage?.toString().split(".")[1] == "0"
                        ? ("${expenseInfo?.percentage?.toStringAsFixed(0)}%" ?? "")
                        : ("${expenseInfo?.percentage?.toStringAsFixed(2)}%" ?? ""),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 16, fontFamily: Fonts.hKGrotesk, color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 34,
                    width: 0.5,
                    color: DefaultThemeColors.nepal,
                  ),
                  SizedBox(width: 8),
                  Container(
                    constraints: BoxConstraints(maxWidth: 60),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        expenseInfo?.amount?.toString().split(".")[1] == "0"
                            ? ("${expenseInfo?.amount?.toStringAsFixed(0)}\n${emp?.currency?.code}")
                            : ("${expenseInfo?.amount?.toStringAsFixed(2)}\n${emp?.currency?.code}"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontSize: 12,
                              height: 1.2,
                              fontFamily: Fonts.hKGrotesk,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
