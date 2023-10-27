import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  LineChartWidget({super.key});

  final List<Color> gradientColors = [Colors.black, Colors.green];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 5,
            // titlesData: LineTitles,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 3),
                  const FlSpot(2, 3),
                  const FlSpot(4, 3),
                  const FlSpot(6, 4),
                  const FlSpot(8, 3),
                  const FlSpot(11, 3),
                ],
                isCurved: true,
                color: const Color(0xff3DD598),
                barWidth: 5,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xff3DD598).withOpacity(0.3)),
              )
            ],
          ),
        ));
  }
}

class LineTitles {
  static getTitleData() => const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)));
}
