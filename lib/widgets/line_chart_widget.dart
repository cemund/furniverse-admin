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
          duration: const Duration(milliseconds: 250),
          LineChartData(
            lineTouchData: _lineTouchData(),
            titlesData: _titlesData(),
            showingTooltipIndicators: [],
            minX: 0,
            maxX: 12,
            minY: 0,
            maxY: 5,
            // titlesData: LineTitles,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 5),
                  const FlSpot(2, 3),
                  const FlSpot(4, 3),
                  const FlSpot(6, 4),
                  const FlSpot(8, 4),
                  const FlSpot(11, 3),
                  const FlSpot(12, 3),
                ],
                isCurved: true,
                isStrokeCapRound: true,
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

  FlTitlesData _titlesData() => FlTitlesData(
      bottomTitles: _bottomTitles(),
      leftTitles: _leftTitles(),
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles());

  AxisTitles _leftTitles() => AxisTitles(
          sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          const style = TextStyle(
            color: Color(0xFF92929D),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          );
          String text;
          switch (value.toInt()) {
            case 0:
              text = '0';
              break;
            case 1:
              text = '200';
              break;
            case 2:
              text = '400';
              break;
            case 3:
              text = '600';
              break;
            case 4:
              text = '800';
              break;
            case 5:
              text = '1k';
              break;
            default:
              return Container();
          }

          return Text(text, style: style, textAlign: TextAlign.center);
        },
      ));

  AxisTitles _bottomTitles() => AxisTitles(
          sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          const style = TextStyle(
            color: Color(0xFF92929D),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          );
          Widget text;
          switch (value.toInt()) {
            case 1:
              text = const Text('MAY', style: style);
              break;
            case 3:
              text = const Text('JUN', style: style);
              break;
            case 5:
              text = const Text('JUL', style: style);
              break;
            case 7:
              text = const Text('AUG', style: style);
              break;
            case 9:
              text = const Text('SEP', style: style);
              break;
            case 11:
              text = const Text('NOV', style: style);
              break;

            default:
              text = const Text('');
              break;
          }

          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 10,
            child: text,
          );
        },
      ));

  LineTouchData _lineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final flSpot = touchedSpot.bar.spots[touchedSpot.spotIndex];
              String tooltipLabel =
                  'X: ${flSpot.x.toStringAsFixed(1)}, Y: ${flSpot.y.toStringAsFixed(1)} \n August';
              return LineTooltipItem(
                tooltipLabel,
                const TextStyle(
                  color: Color(0xFF696974),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: 0.09,
                ),
              );
            }).toList();
          }),
    );
  }
}
