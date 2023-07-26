import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/single_tap_tooltip.dart';

var preferredCount = 8;

int getNewHighest(int highest) {
  var newHighest = highest;
  while (newHighest % 5 != 0) {
    newHighest++;
  }
  return newHighest;
}

Widget yTitles(int highestNumber, BuildContext context,
    [double bottomPadding = 50]) {
  var newHighest = getNewHighest(highestNumber);
  var sectorSizeMin = (newHighest / preferredCount).ceil();
  var sectorSizeMax = (newHighest);
  int sectorSize = sectorSizeMin;
  if ((newHighest / sectorSize) == (newHighest / sectorSize).floor()) {
  } else {
    while ((newHighest / sectorSize) != (newHighest / sectorSize).floor()) {
      sectorSize++;
      if (sectorSize < 1) {
        break;
      }
    }
  }

  var nums = <int>[];
  var current = 0;
  while (current <= newHighest) {
    nums.insert(0, current);
    current += sectorSize;
  }

  return Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (highestNumber > 8) ...[
              for (final index
                  in List.generate(nums.length, (index) => nums[index]))
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 12, maxWidth: 12),
                    child: FittedBox(
                      child: Text(
                        index.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ] else ...[
              for (final index in List.generate(
                  (highestNumber + 1), (index) => (highestNumber - index)))
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 12, maxWidth: 12),
                    child: FittedBox(
                      child: Text(
                        index.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
      SizedBox(height: bottomPadding),
    ],
  );
}

Widget chartLine(
    int value, int highestNumber, double chartHeight, bool forScreenshot,
    {int? index}) {
  var newHighest = 8;
  if (value > 8) {
    newHighest = getNewHighest(highestNumber);
  }

  return SingleTapTooltip(
    message: forScreenshot ? null : value.toString(),
    verticalOffset: -120.0,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        height: max(((value / highestNumber) * (chartHeight - 50)), 10.0),
        width: 8,
        decoration: BoxDecoration(
          color: colorBallet[index ?? 0],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}
