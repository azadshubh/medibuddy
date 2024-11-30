import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class AnalyticsDashboard extends StatelessWidget {
  // Dummy data generator
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
        backgroundColor: Colors.blue[800],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          // Age Distribution Chart
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Age Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: AgeDistributionChart()),
                ],
              ),
            ),
          ),
          
          // Blood Pressure Trends
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Blood Pressure Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: BloodPressureChart()),
                ],
              ),
            ),
          ),
          
          // Most Prescribed Medicines
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Most Prescribed Medicines', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: MedicineFrequencyChart()),
                ],
              ),
            ),
          ),
          
          // Doctor Performance Metrics
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Doctor Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: DoctorMetricsCard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Age Distribution Chart
class AgeDistributionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${(value * 10).toInt()}');
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 65)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 85)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 75)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 55)]),
        ],
      ),
    );
  }
}

// Blood Pressure Chart
class BloodPressureChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 120),
              FlSpot(1, 125),
              FlSpot(2, 118),
              FlSpot(3, 122),
              FlSpot(4, 128),
            ],
            isCurved: true,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

// Medicine Frequency Chart
class MedicineFrequencyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 35,
            title: 'Paracetamol',
            color: Colors.blue,
            radius: 50,
          ),
          PieChartSectionData(
            value: 25,
            title: 'Aspirin',
            color: Colors.red,
            radius: 50,
          ),
          PieChartSectionData(
            value: 40,
            title: 'Others',
            color: Colors.green,
            radius: 50,
          ),
        ],
      ),
    );
  }
}

// Doctor Metrics Card
class DoctorMetricsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Dr. Smith'),
          subtitle: Text('Patients: 150'),
          trailing: Icon(Icons.trending_up, color: Colors.green),
        ),
        ListTile(
          title: Text('Dr. Johnson'),
          subtitle: Text('Patients: 120'),
          trailing: Icon(Icons.trending_flat, color: Colors.blue),
        ),
        ListTile(
          title: Text('Dr. Williams'),
          subtitle: Text('Patients: 90'),
          trailing: Icon(Icons.trending_up, color: Colors.green),
        ),
      ],
    );
  }
}