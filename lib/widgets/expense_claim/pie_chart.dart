import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';

import 'indicator.dart';

class PieChartWidget extends StatefulWidget {
  final ExpenseResponse? expenseClaim;

  const PieChartWidget({Key? key, this.expenseClaim}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartWidget> {
  int touchedIndex = -1;
  double radius = 50.0;
  Expenses? selectedExpense;

  @override
  void initState() {
    super.initState();

    selectedExpense = widget.expenseClaim?.expenses?.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        setState(() {
                          final desiredTouch = event.runtimeType == FlTapUpEvent;
                          if (desiredTouch && pieTouchResponse?.touchedSection?.touchedSection != null) {
                            touchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                            selectedExpense = widget.expenseClaim?.expenses![touchedIndex];
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Indicator(
                color: Color(int.tryParse(selectedExpense!.color!)!),
                text: selectedExpense!.name,
                percentage: selectedExpense?.percentage?.toString().split(".")[1] == "0"
                    ? selectedExpense?.percentage?.toStringAsFixed(0)
                    : selectedExpense?.percentage?.toStringAsFixed(2),
                isSquare: false,
              ),
            )
          ],
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 30,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(left: 12),
            itemCount: widget.expenseClaim?.expenses?.length,
            itemBuilder: (BuildContext context, int index) {
              Expenses expenseInfo = widget.expenseClaim!.expenses![index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedExpense = expenseInfo;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.tryParse(expenseInfo.color!)!),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        expenseInfo.name ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: Fonts.brandon,
                          color: Theme.of(context).primaryColor,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.expenseClaim!.expenses!.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 14.0;
      radius = isTouched ? 45.0 : 35.0;
      List<PieChartSectionData> date = widget.expenseClaim!.expenses!
          .map(
            (e) => PieChartSectionData(
              showTitle: false,
              color: Color(int.tryParse(e.color!)!),
              value: e.amount,
              title: '${e.percentage?.toStringAsFixed(2)}%',
              radius: radius,
              titleStyle: TextStyle(fontSize: fontSize, fontFamily: Fonts.brandon, color: const Color(0xffffffff)),
            ),
          )
          .toList();
      return date[i];
    });
  }
}
