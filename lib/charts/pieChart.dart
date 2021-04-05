import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

List<PieChartSectionData> showingSections() {
  return List.generate(4, (i) {
    final isTouched = i == -1;
    final double fontSize = isTouched ? 25 : 16;
    final double radius = isTouched ? 60 : 50;
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: const Color(0xff0293ee),
          value: 40,
          title: '40%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      case 1:
        return PieChartSectionData(
          color: const Color(0xfff8b250),
          value: 30,
          title: '30%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      case 2:
        return PieChartSectionData(
          color: const Color(0xff845bef),
          value: 15,
          title: '15%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      case 3:
        return PieChartSectionData(
          color: const Color(0xff13d38e),
          value: 15,
          title: '15%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      default:
        return null;
    }
  });
}