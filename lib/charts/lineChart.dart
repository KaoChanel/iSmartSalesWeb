import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ismart_crm/models/sales.dart';
import 'package:ismart_crm/models/sales_monthly.dart';

getQuarter(DateTime date) {
  if (date.month >= 1 && date.month <= 3)
    return 1;
  else if (date.month >= 4 && date.month <= 6)
    return 2;
  else if (date.month >= 7 && date.month <= 9)
    return 3;
  else
    return 4;
}

getMonthName(int month){
  switch(month){
    case 1: {
      return 'January';
    }
    case 2: {
      return 'February';
    }
    case 3: {
      return 'March';
    }
    case 4: {
      return 'April';
    }
    case 5: {
      return 'May';
    }
    case 6: {
      return 'June';
    }
    case 7: {
      return 'July';
    }
    case 8: {
      return 'August';
    }
    case 9: {
      return 'September';
    }
    case 10: {
      return 'October';
    }
    case 11: {
      return 'November';
    }
    case 12: {
      return 'December';
    }
  }
}

LineChart lineChartQuarter(List<SalesMonthly> dataSet) {
  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  int _leftLabelsCount = 6;
  double _leftTitlesInterval = 0;

  /// Declare X and Y core.
  List<FlSpot> _allSpots = <FlSpot>[];
  List<SalesMonthly> quarterSales = <SalesMonthly>[];
  switch(getQuarter(DateTime.now())){
    case 1: {
      _minX = 1;
      _maxX = 3;
      quarterSales = dataSet
          .where((x) => DateTime.now().year == x.xYear && x.xMonth == 1 || x.xMonth == 2 || x.xMonth == 3)
          .toList();
      break;
    }
    case 2: {
      _minX = 4;
      _maxX = 6;
      quarterSales = dataSet
          .where((x) => DateTime.now().year == x.xYear && x.xMonth == 4 || x.xMonth == 5 || x.xMonth == 6)
          .toList();
      break;
    }
    case 3: {
      _minX = 7;
      _maxX = 9;
      quarterSales = dataSet
          .where((x) => DateTime.now().year == x.xYear && x.xMonth == 7 || x.xMonth == 8 || x.xMonth == 9)
          .toList();
      break;
    }
    case 4: {
      _minX = 10;
      _maxX = 12;
      quarterSales = dataSet
          .where((x) => DateTime.now().year == x.xYear && x.xMonth == 10 || x.xMonth == 11 || x.xMonth == 12)
          .toList();
      break;
    }
  }

  quarterSales.sort((a, b) => a.xMonth.compareTo(b.xMonth));

  _allSpots = quarterSales
      .map((e) => FlSpot(e.xMonth.toDouble(), e.totaExcludeAmnt))
      .toList();

  double minAmount = quarterSales
      ?.reduce((current, next) =>
  current.totaExcludeAmnt < next.totaExcludeAmnt ? next : current)
      ?.totaExcludeAmnt ??
      0;
  double maxAmount = quarterSales
      ?.reduce((current, next) =>
  current.totaExcludeAmnt > next.totaExcludeAmnt ? current : next)
      ?.totaExcludeAmnt ??
      0;

  double minY = minAmount;
  double maxY = maxAmount;
  final int _divider = maxAmount.toInt();

  quarterSales.forEach((e) {
    if (minY > e.totaExcludeAmnt) minY = e.totaExcludeAmnt;
    if (maxY < e.totaExcludeAmnt) maxY = e.totaExcludeAmnt;
  });

  // _minX = _allSpots.first.x;
  // _maxX = _allSpots.last.x;
  _minY = (minY / _divider).floorToDouble() * _divider;
  _maxY = (maxY / _divider).ceilToDouble() * _divider;
  _leftTitlesInterval =
      ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

  print('maxFinite: $minY');
  print('minPositive: $maxY');
  print('Min X : $_minX');
  print('Max X : $_maxX');
  print('Min Y : $_minY');
  print('Max Y : $_maxY');
  print('Max Y Celi : ${_maxY.round()}');
  print('_leftTitlesInterval : $_leftTitlesInterval');

  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];

  /// Filling all of FLSpot.
  final LineChartBarData _lineChartBarData = LineChartBarData(
    spots: _allSpots,
    isCurved: false,
    // colors: [
    //   const Color(0xff4af699),
    // ],
    colors: _gradientColors,
    colorStops: const [0.25, 0.5, 0.75],
    gradientFrom: const Offset(0.5, 0),
    gradientTo: const Offset(0.5, 1),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: true,
      colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      gradientColorStops: const [0.25, 0.5, 0.75],
      gradientFrom: const Offset(0.5, 0),
      gradientTo: const Offset(0.5, 1),
    ),
  );

  final _leftTitles = SideTitles(
    showTitles: true,
    getTextStyles: (value) => const TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    getTitles: (value) {
      return NumberFormat.compact().format(value ?? 0.0);
    },
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
        return getMonthName(value.toInt());
      },
      // interval: 3
  );

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


  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: _gridData(),
      titlesData:
          FlTitlesData(bottomTitles: _bottomTitle, leftTitles: _leftTitles),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: _minX,
      maxX: _maxX,
      maxY: _maxY,
      minY: _minY,
      lineBarsData: [_lineChartBarData],
    ),
    swapAnimationDuration: const Duration(milliseconds: 250),
  );
}

LineChart sampleData1(List<Sales> dataSet) {
  double _minX = 1;
  double _maxX = 31;
  double _minY = 0;
  double _maxY = 0;
  double minAmount = dataSet
          ?.reduce((current, next) =>
              current.totaExcludeAmnt < next.totaExcludeAmnt ? next : current)
          ?.totaExcludeAmnt ??
      0;
  double maxAmount = dataSet
          ?.reduce((current, next) =>
              current.totaExcludeAmnt > next.totaExcludeAmnt ? current : next)
          ?.totaExcludeAmnt ??
      0;
  final int _divider = maxAmount.toInt();
  int _leftLabelsCount = 6;
  double _leftTitlesInterval = 0;
  final currency = NumberFormat("#,##0.00", "en_US");

  /// Declare X and Y core.
  final List<FlSpot> _allSpots = dataSet
      .where((x) => x.docuDate.month == DateTime.now().month)
      .map((e) => FlSpot(e.xDay.toDouble(), e.totaExcludeAmnt))
      .toList();

  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];

  // double minY = double.maxFinite;
  // double maxY = double.minPositive;

  double minY = minAmount;
  double maxY = maxAmount;

  dataSet.where((x) => x.docuDate.month == DateTime.now().month).forEach((e) {
    if (minY > e.totaExcludeAmnt) minY = e.totaExcludeAmnt;
    if (maxY < e.totaExcludeAmnt) maxY = e.totaExcludeAmnt;
  });

  _minX = _allSpots.first.x;
  _maxX = _allSpots.last.x;
  _minY = (minY / _divider).floorToDouble() * _divider;
  _maxY = (maxY / _divider).ceilToDouble() * _divider / 1.5;
  _leftTitlesInterval =
      ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

  print('maxFinite: $minY');
  print('minPositive: $maxY');
  print('Min X : $_minX');
  print('Max X : $_maxX');
  print('Min Y : $_minY');
  print('Max Y : $_maxY');
  print('Max Y Celi : ${_maxY.round()}');
  print('_leftTitlesInterval : $_leftTitlesInterval');

  /// Filling all of FLSpot.
  final LineChartBarData _lineChartBarData = LineChartBarData(
    spots: _allSpots,
    isCurved: false,
    // colors: [
    //   const Color(0xff4af699),
    // ],
    colors: _gradientColors,
    colorStops: const [0.25, 0.5, 0.75],
    gradientFrom: const Offset(0.5, 0),
    gradientTo: const Offset(0.5, 1),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: true,
      colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      gradientColorStops: const [0.25, 0.5, 0.75],
      gradientFrom: const Offset(0.5, 0),
      gradientTo: const Offset(0.5, 1),
    ),
  );

  final _leftTitles = SideTitles(
    showTitles: true,
    getTextStyles: (value) => const TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    getTitles: (value) {
      return NumberFormat.compact().format(value ?? 0.0);
    },
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
      interval: (_maxX - _minX) / 10);

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

  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: _gridData(),
      titlesData:
          FlTitlesData(bottomTitles: _bottomTitle, leftTitles: _leftTitles),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: _minX,
      maxX: _maxX,
      maxY: _maxY,
      minY: _minY,
      lineBarsData: [_lineChartBarData],
    ),
    swapAnimationDuration: const Duration(milliseconds: 250),
  );
}

List<LineChartBarData> linesBarData1() {
  final LineChartBarData lineChartBarData1 = LineChartBarData(
    spots: [
      FlSpot(5, 1),
      FlSpot(12, 1.5),
      FlSpot(25, 1.8),
      FlSpot(26, 1),
      // FlSpot(13, 2.2),
      // FlSpot(18, 1.8),
      FlSpot(30, 2),
      FlSpot(31, 2.8),
    ],
    isCurved: true,
    colors: [
      const Color(0xff4af699),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData lineChartBarData2 = LineChartBarData(
    spots: [
      // FlSpot(1, 1),
      // FlSpot(2, 2.8),
      // FlSpot(3, 1.2),
      // FlSpot(4, 2.8),
      // FlSpot(5, 2.6),
      // FlSpot(6, 3.9),
      // FlSpot(15, 3.4),
      // FlSpot(26, 2),
      // FlSpot(27, 2.2),
      // FlSpot(30, 0),

      FlSpot(5, 1),
      FlSpot(12, 1.5),
      FlSpot(25, 1.8),
      FlSpot(26, 1),
      // FlSpot(13, 2.2),
      // FlSpot(18, 1.8),
      FlSpot(30, 2),
      FlSpot(31, 2.8),
    ],
    isCurved: true,
    colors: [
      const Color(0xffaa4cfc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: false, colors: [
      const Color(0x00aa4cfc),
    ]),
  );
  // final LineChartBarData lineChartBarData3 = LineChartBarData(
  //   spots: [
  //     FlSpot(1, 2.8),
  //     FlSpot(3, 1.9),
  //     FlSpot(6, 3),
  //     FlSpot(10, 1.3),
  //     FlSpot(13, 2.5),
  //   ],
  //   isCurved: true,
  //   colors: const [
  //     Color(0xff27b6fc),
  //   ],
  //   barWidth: 8,
  //   isStrokeCapRound: true,
  //   dotData: FlDotData(
  //     show: false,
  //   ),
  //   belowBarData: BarAreaData(
  //     show: false,
  //   ),
  // );
  return [
    lineChartBarData1,
    //lineChartBarData2,
    // lineChartBarData3,
  ];
}

LineChart sampleData2() {
  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return DateFormat.MMM().format(DateTime.now());
              case 7:
                return DateFormat.MMM()
                    .format(DateTime.now().add(Duration(days: 30)));
              case 12:
                return DateFormat.MMM()
                    .format(DateTime.now().add(Duration(days: 60)));
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData2(),
    ),
    swapAnimationDuration: const Duration(milliseconds: 250),
  );
}

List<LineChartBarData> linesBarData2() {
  return [
    LineChartBarData(
      spots: [
        // FlSpot(1, 1),
        // FlSpot(3, 4),
        // FlSpot(5, 1.8),
        // FlSpot(7, 5),
        // FlSpot(10, 2),
        // FlSpot(12, 2.2),
        // FlSpot(13, 1.8),

        FlSpot(5, 1),
        FlSpot(12, 1.5),
        FlSpot(25, 1.8),
        FlSpot(26, 1),
        // FlSpot(13, 2.2),
        // FlSpot(18, 1.8),
        FlSpot(30, 2),
        FlSpot(31, 2.8),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: const [
        Color(0x444af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
    LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: const [
        Color(0x99aa4cfc),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: true, colors: [
        const Color(0x33aa4cfc),
      ]),
    ),
    LineChartBarData(
      spots: [
        FlSpot(1, 3.8),
        FlSpot(3, 1.9),
        FlSpot(6, 5),
        FlSpot(10, 3.3),
        FlSpot(13, 4.5),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: const [
        Color(0x4427b6fc),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
  ];
}

LineChart sampleData3() {
  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'JAN';
              case 2:
                return 'FEB';
              case 3:
                return 'MAR';
              case 4:
                return 'APR';
              case 5:
                return 'MAY';
              case 6:
                return 'JUN';
              case 7:
                return 'JUL';
              case 8:
                return 'AUG';
              case 9:
                return 'SEP';
              case 10:
                return 'OCT';
              case 11:
                return 'NOV';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: 6,
      minY: 0,
      lineBarsData: linesBarData2(),
    ),
    swapAnimationDuration: const Duration(milliseconds: 250),
  );
}

List<LineChartBarData> linesBarData3() {
  return [
    LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 4),
        FlSpot(5, 1.8),
        FlSpot(7, 5),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
        FlSpot(3, 4),
        FlSpot(3, 4),
        FlSpot(3, 4),
        FlSpot(3, 4),
        FlSpot(3, 4),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: const [
        Color(0x444af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
    LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
        FlSpot(3, 2.8),
        FlSpot(3, 2.8),
        FlSpot(3, 2.8),
        FlSpot(3, 2.8),
        FlSpot(3, 2.8),
        FlSpot(3, 2.8),
      ],
      isCurved: true,
      colors: const [
        Color(0x99aa4cfc),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: true, colors: [
        const Color(0x33aa4cfc),
      ]),
    ),
    LineChartBarData(
      spots: [
        FlSpot(1, 3.8),
        FlSpot(3, 1.9),
        FlSpot(6, 5),
        FlSpot(10, 3.3),
        FlSpot(13, 4.5),
        FlSpot(3, 1.9),
        FlSpot(3, 1.9),
        FlSpot(3, 1.9),
        FlSpot(3, 1.9),
        FlSpot(3, 1.9),
        FlSpot(3, 1.9),
        FlSpot(3, 1.9),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: const [
        Color(0x4427b6fc),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
  ];
}
