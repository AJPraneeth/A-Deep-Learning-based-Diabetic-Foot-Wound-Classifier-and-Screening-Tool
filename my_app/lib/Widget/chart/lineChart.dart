import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Repository/WoundRepository/wound_repository.dart';
import 'package:my_app/Theme/theme.dart';

class LineChartWidget extends StatefulWidget {
  final List<WoundChartData> chartData;
  final double minx;
  final double maxx;
  final double miny;
  final double maxy;
  final double avg;
  const LineChartWidget(
      {Key? key,
      required this.chartData,
      required this.minx,
      required this.maxx,
      required this.maxy,
      required this.miny,
      required this.avg})
      : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<Color> gradientColors = [contentColorBlue, contentColorCyan];
  bool showAvg = false;
  double minDay = 0;

  List<FlSpot> woundAreaSports(List<WoundChartData> chartData) {
    return chartData
        .map((data) => FlSpot(data.day.toDouble(), data.woundArea))
        .toList();
  }

  List<FlSpot> woundAreaSportsAverage(List<WoundChartData> chartData, avg) {
    Map<int, List<double>> dayToWoundAreas = {};

    // Collect wound areas for each day
    for (var data in chartData) {
      int day = data.day;
      double wound = data.woundArea;

      if (!dayToWoundAreas.containsKey(day)) {
        dayToWoundAreas[day] = [];
      }

      dayToWoundAreas[day]!.add(wound);
    }

    // Calculate the average wound area for each day
    List<FlSpot> averageSpots = [];
    dayToWoundAreas.forEach((day, areas) {
      double avgWound = areas.isNotEmpty ? avg : 0.0;

      averageSpots.add(FlSpot(day.toDouble(), avgWound));
    });

    return averageSpots;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          height: 40,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 20,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 10,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: white.withOpacity(0.5));
    // Calculate the interval between titles based on the range of days
    int interval = ((widget.maxx - widget.minx) / 3).ceil();

    // Show titles only at intervals and within the chart's min-max range
    if (value >= widget.minx &&
        value <= widget.maxx &&
        (value - widget.minx) % interval == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text('Day ${value.toInt()}', style: style),
      );
    }
    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: white.withOpacity(0.5));
    // Calculate the interval between titles based on the range of wound areas
    double interval = ((widget.maxy - widget.miny) / 3);

    // Calculate the titles to display
    List<String> titles = [];
    for (int i = 0; i <= 2; i++) {
      double titleValue = widget.miny + (i * interval);

      titles.add(titleValue.toStringAsFixed(2)); // Limit to 2 decimal places
    }

    // Show titles only at the calculated intervals and within the chart's min-max range
    if (titles.isNotEmpty) {
      return Text(value.toStringAsFixed(2),
          style: style, textAlign: TextAlign.left);
    }

    // Return an empty container for non-displayed titles
    return Container();
  }

  LineChartData mainData() {
    return LineChartData(
      backgroundColor: menuBackground,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: widget.minx,
      maxX: widget.maxx + 1,
      minY: widget.miny - 1,
      maxY: widget.maxy + 1,
      lineBarsData: [
        LineChartBarData(
          spots: woundAreaSports(widget.chartData),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      backgroundColor: menuBackground,
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: widget.minx,
      maxX: widget.maxx,
      minY: widget.miny,
      maxY: widget.maxy,
      lineBarsData: [
        LineChartBarData(
          spots: woundAreaSportsAverage(widget.chartData, widget.avg),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
