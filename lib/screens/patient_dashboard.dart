import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PatientSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const PatientSearchBar({
    Key? key,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Enter Patient ID (e.g., P12345)',
            prefixIcon: Icon(Icons.person_search),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                onSearch('');
              },
            ),
          ),
          onChanged: onSearch,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.characters,
        ),
      ),
    );
  }
}

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final TextEditingController _searchController = TextEditingController();
  bool _showPatientData = false;
  String _searchQuery = '';

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _showPatientData = query.toUpperCase() == 'P12345';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatientSearchBar(
              searchController: _searchController,
              onSearch: _handleSearch,
            ),
            SizedBox(height: 20),
            if (!_showPatientData && _searchQuery.isNotEmpty)
              Center(
                child: Text(
                  'No patient found with ID "$_searchQuery"',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            if (_showPatientData) ...[
              PatientInfoCard(),
              SizedBox(height: 20),
              MedicalHistoryTimeline(),
              SizedBox(height: 20),
              VitalStatisticsChart(),
              SizedBox(height: 20),
              CurrentMedicationsCard(),
              SizedBox(height: 20),
              UpcomingAppointments(),
            ],
          ],
        ),
      ),
    );
  }
}

class PatientInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text('JD'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('Patient ID: P12345'),
                    Text('Age: 45 | Blood Group: O+'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalHistoryTimeline extends StatelessWidget {
  final List<Map<String, String>> medicalHistory = [
    {
      'date': '2024-03-15',
      'event': 'Annual Checkup',
      'details': 'Regular health examination - All parameters normal'
    },
    {
      'date': '2024-02-20',
      'event': 'Flu Treatment',
      'details': 'Prescribed antibiotics for severe cold'
    },
    {
      'date': '2024-01-10',
      'event': 'Dental Procedure',
      'details': 'Root canal treatment'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: medicalHistory.length,
              itemBuilder: (context, index) {
                return TimelineTile(
                  isFirst: index == 0,
                  isLast: index == medicalHistory.length - 1,
                  endChild: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicalHistory[index]['event']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(medicalHistory[index]['date']!),
                        Text(medicalHistory[index]['details']!),
                      ],
                    ),
                  ),
                  indicatorStyle: IndicatorStyle(
                    width: 20,
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VitalStatisticsChart extends StatelessWidget {
  final List<FlSpot> bloodPressureData = [
    FlSpot(0, 120),
    FlSpot(1, 122),
    FlSpot(2, 118),
    FlSpot(3, 125),
    FlSpot(4, 121),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vital Statistics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: bloodPressureData,
                      isCurved: true,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentMedicationsCard extends StatelessWidget {
  final List<Map<String, String>> medications = [
    {
      'name': 'Amoxicillin',
      'dosage': '500mg',
      'frequency': 'Twice daily',
      'duration': '7 days'
    },
    {
      'name': 'Paracetamol',
      'dosage': '650mg',
      'frequency': 'As needed',
      'duration': '5 days'
    },
    {
      'name': 'Vitamin D3',
      'dosage': '60,000 IU',
      'frequency': 'Once weekly',
      'duration': '8 weeks'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Medications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.medication),
                  title: Text(medications[index]['name']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dosage: ${medications[index]['dosage']}'),
                      Text('Frequency: ${medications[index]['frequency']}'),
                      Text('Duration: ${medications[index]['duration']}'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingAppointments extends StatelessWidget {
  final List<Map<String, String>> appointments = [
    {
      'doctor': 'Dr. Smith',
      'specialty': 'Cardiologist',
      'date': '2024-03-25',
      'time': '10:00 AM'
    },
    {
      'doctor': 'Dr. Johnson',
      'specialty': 'Dentist',
      'date': '2024-04-05',
      'time': '2:30 PM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(appointments[index]['doctor']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointments[index]['specialty']!),
                      Text('${appointments[index]['date']} at ${appointments[index]['time']}'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}