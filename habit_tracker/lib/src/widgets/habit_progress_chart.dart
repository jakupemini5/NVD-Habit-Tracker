import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_model.dart';
import 'package:intl/intl.dart';

class HabitProgressChart extends StatelessWidget {
  final HabitModel habit;

  const HabitProgressChart({Key? key, required this.habit}) : super(key: key);

  List<FlSpot> _getSpots() {
    // Sort history by date
    final sortedHistory = habit.history.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Create spots for the line chart
    return sortedHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.numberReached.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getSpots();
    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white10,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.white10,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= habit.history.length) {
                      return const SizedBox();
                    }
                    final date = habit.history[value.toInt()].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('MM/dd').format(date),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white10),
            ),
            minX: 0,
            maxX: (spots.length - 1).toDouble(),
            minY: 0,
            maxY: spots.map((e) => e.y).reduce((a, b) => a > b ? a : b),
            lineBarsData: [
              // Progress Line
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.green,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.green,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green.withOpacity(0.1),
                ),
              ),
              // Target Line
              if (habit.targetNumber != null)
                LineChartBarData(
                  spots: [
                    FlSpot(0, habit.targetNumber!.toDouble()),
                    FlSpot((spots.length - 1).toDouble(), habit.targetNumber!.toDouble()),
                  ],
                  isCurved: false,
                  color: Colors.orange,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  dashArray: [5, 5], // Creates a dashed line
                ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.grey.shade800,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final date = habit.history[touchedSpot.x.toInt()].date;
                    return LineTooltipItem(
                      '${DateFormat('MM/dd').format(date)}\n',
                      const TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: touchedSpot.y.toInt().toString(),
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}