import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

LineChart sampleData1() {
  return LineChart(
    LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {},
      handleBuiltInTouches: true,
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
            // case 1:
            //   return '1';
            // case 2:
            //   return '2';
            // case 3:
            //   return '3';
            // case 4:
            //   return '4';
            case 5:
              return '5';
            // case 6:
            //   return '6';
            // case 7:
            //   return '7';
            // case 8:
            //   return '8';
            // case 9:
            //   return '9';
            // case 10:
            //   return '10';
            // case 11:
            //   return '11';
            case 12:
              return '12';
            // case 13:
            //   return '13';
            // case 14:
            //   return '14';
            // case 20:
            //   return '20';
            // case 21:
            //   return '21';
            // case 22:
            //   return '22';
            // case 23:
            //   return '23';
            // case 24:
            //   return '24';
            case 25:
              return '25';
            case 26:
              return '26';
            // case 27:
            //   return '27';
            // case 28:
            //   return '28';
            // case 29:
            //   return '29';
            case 30:
              return '30';
            case 31:
              return '31';
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
      ),
    ),
    minX: 0,
    maxX: 31,
    maxY: 4,
    minY: 0,
    lineBarsData: linesBarData1(),
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
              return DateFormat.MMM().format(DateTime.now().add(Duration(days: 30)));
            case 12:
              return DateFormat.MMM().format(DateTime.now().add(Duration(days: 60)));
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