import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:ismart_crm/models/sales.dart';
import 'package:ismart_crm/models/sales_daily.dart';

final Color leftBarColor = const Color(0xff53fdd7);
final Color rightBarColor = const Color(0xffff5182);
final double width = 20;

final barGroup1 = makeGroupData(0, 5, 12);
final barGroup2 = makeGroupData(1, 16, 12);
final barGroup3 = makeGroupData(2, 18, 5);
final barGroup4 = makeGroupData(3, 20, 16);
final barGroup5 = makeGroupData(4, 17, 6);
final barGroup6 = makeGroupData(5, 19, 1.5);
final barGroup7 = makeGroupData(6, 9, 1.5);
final barGroup8 = makeGroupData(7, 12, 1.5);
final barGroup9 = makeGroupData(8, 15, 1.5);
final barGroup10 = makeGroupData(9, 14, 1.5);
final barGroup11 = makeGroupData(10, 21, 1.5);
final barGroup12 = makeGroupData(11, 13, 1.5);

final items = [
  barGroup1,
  barGroup2,
  barGroup3,
  barGroup4,
  barGroup5,
  barGroup6,
  barGroup7,
  barGroup8,
  barGroup9,
  barGroup10,
  barGroup11,
  barGroup12,
];

makeRodData(List<SalesDaily> dataSet, int day, double total) {
  return dataSet.where((x) => x.docuDate.month == DateTime.now().month && x.xDay == day && x.totaExcludeAmnt == total)
      .map((e) => BarChartRodData(y: e.totaExcludeAmnt, colors: [Colors.lightBlueAccent, Colors.greenAccent])).toList();
}

BarChart barChart(List<SalesDaily> dataSet) {
  double _minX = 1;
  double _maxX = 31;
  double _minY = 0;
  double _maxY = 0;

  final int _leftLabelsCount = 6;
  double _leftTitlesInterval = 0;

  /// Declare X and Y core.
  List<SalesDaily> monthlySales = dataSet.where((x) => x.docuDate.month == DateTime.now().month).toList();
  final List<BarChartGroupData> _allBarGroupData = monthlySales
      .map((e) => BarChartGroupData(x: e.xDay, barRods: makeRodData(monthlySales, e.xDay, e.totaExcludeAmnt), showingTooltipIndicators: [0])).toList();

  double minAmount = monthlySales?.reduce((current, next) => current.totaExcludeAmnt < next.totaExcludeAmnt ? next : current)?.totaExcludeAmnt ?? 0;
  double maxAmount = monthlySales?.reduce((current, next) => current.totaExcludeAmnt > next.totaExcludeAmnt ? current : next)?.totaExcludeAmnt ?? 0;
  final int _divider = maxAmount.toInt();

  double minY = minAmount;
  double maxY = maxAmount;

  monthlySales.forEach((e) {
    if (minY > e.totaExcludeAmnt) minY = e.totaExcludeAmnt;
    if (maxY < e.totaExcludeAmnt) maxY = e.totaExcludeAmnt;
  });

  _minX = _allBarGroupData.first.x.toDouble();
  _maxX = _allBarGroupData.last.x.toDouble();
  _minY = (minY / _divider).floorToDouble() * _divider;
  _maxY = (maxY / _divider).ceilToDouble() * _divider;
  _leftTitlesInterval =
      ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval == 0;
      },
    );
  }

  final _leftTitles = SideTitles(
    showTitles: true,
    getTextStyles: (value) => const TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    // getTitles: (value) {
    //   return NumberFormat.compact().format(value ?? 0.0);
    // },
    margin: 8,
    reservedSize: 50,
    interval: _leftTitlesInterval,
  );

  final _bottomTitle = SideTitles(
      showTitles: true,
      reservedSize: 25,
      margin: 10,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xff72719b),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      getTitles: (value) {
        return value.toInt().toString();
      },
      interval: (_maxX - _minX) / 10
  );

  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: _maxY,
      minY: _minY,
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipBottomMargin: 8,
          getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
              ) {
            return BarTooltipItem(
              NumberFormat.compact().format(rod.y.round()),
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      gridData: _gridData(),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: _bottomTitle,
        leftTitles: _leftTitles,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _allBarGroupData,
    ),
  );
}

List<BarChartGroupData> rawBarGroups = items;

List<BarChartGroupData> showingBarGroups = rawBarGroups;

BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(barsSpace: 4, x: x, barRods: [
    BarChartRodData(
      y: y1,
      colors: [y1 > 15 ? rightBarColor : leftBarColor],
      width: width,
    ),
    // BarChartRodData(
    //   y: y2,
    //   colors: [rightBarColor],
    //   width: width,
    // ),
  ]);
}

BarChart barChart1() {
  return BarChart(
      BarChartData(
      maxY: 20,
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey,
            getTooltipItem: (_a, _b, _c, _d) => null,
          ),
          touchCallback: (response) {
            // if (response.spot == null) {
            //   setState(() {
            //     touchedGroupIndex = -1;
            //     showingBarGroups = List.of(rawBarGroups);
            //   });
            //   return;
            // }
            //
            // touchedGroupIndex = response.spot.touchedBarGroupIndex;
            //
            // setState(() {
            //   if (response.touchInput is FlLongPressEnd ||
            //       response.touchInput is FlPanEnd) {
            //     touchedGroupIndex = -1;
            //     showingBarGroups = List.of(rawBarGroups);
            //   } else {
            //     showingBarGroups = List.of(rawBarGroups);
            //     if (touchedGroupIndex != -1) {
            //       double sum = 0;
            //       for (BarChartRodData rod
            //       in showingBarGroups[touchedGroupIndex].barRods) {
            //         sum += rod.y;
            //       }
            //       final avg =
            //           sum / showingBarGroups[touchedGroupIndex].barRods.length;
            //
            //       showingBarGroups[touchedGroupIndex] =
            //           showingBarGroups[touchedGroupIndex].copyWith(
            //             barRods: showingBarGroups[touchedGroupIndex].barRods
            //                 .map((rod) {
            //               return rod.copyWith(y: avg);
            //             }).toList(),
            //           );
            //     }
            //   }
            // });
          }),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>
          const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 20,
          reservedSize: 24,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Jan';
              case 1:
                return 'Feb';
              case 2:
                return 'Mar';
              case 3:
                return 'Apr';
              case 4:
                return 'May';
              case 5:
                return 'Jun';
              case 6:
                return 'Jul';
              case 7:
                return 'Aug';
              case 8:
                return 'Sep';
              case 9:
                return 'Oct';
              case 10:
                return 'Nov';
              case 11:
                return 'Dec';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>
          const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 35,
          reservedSize: 30,
          getTitles: (value) {
            if (value == 0) {
              return '1K';
            } else if (value == 10) {
              return '5K';
            } else if (value == 19) {
              return '10K';
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingBarGroups,
    ),
    swapAnimationDuration: const Duration(milliseconds: 550),
  );
}