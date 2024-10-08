import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the FL chart package
import 'admin_drawer.dart';
import 'package:pdf/widgets.dart' as pw; // Import pdf package
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String _generatedReport = '';
  bool _isLoading = true;

  // Data for charts and report
  List<PieChartSectionData> reportData = [];
  List<PieChartSectionData> feedbackData = [];
  List<PieChartSectionData> truckStatusData = [];

  Map<String, dynamic> reportSummary = {
    'pending': 0,
    'done': 0,
    'excellent': 0,
    'good': 0,
    'activeTrucks': 0,
    'inactiveTrucks': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  // Fetch dashboard data from Firebase
  Future<void> _fetchDashboardData() async {
    const apiUrl = 'https://greenroute-7251d-default-rtdb.firebaseio.com/'; // Firebase base URL

    try {
      final reportsResponse = await http.get(Uri.parse('$apiUrl/reports.json'));
      final feedbackResponse = await http.get(Uri.parse('$apiUrl/feedback.json'));
      final trucksResponse = await http.get(Uri.parse('$apiUrl/garbage_trucks.json'));

      // Parse the responses from Firebase
      final reportsData = json.decode(reportsResponse.body) as Map<String, dynamic>; // Parse as Map
      final feedbackData = json.decode(feedbackResponse.body) as List<dynamic>; // Parse as List
      final trucksData = json.decode(trucksResponse.body) as Map<String, dynamic>; // Parse as Map

      // Process the data for reports, feedback, and trucks
      setState(() {
        // Reports data (handle as Map)
        int pendingReports = reportsData.values.where((r) => r['status'] == 'pending').length;
        int doneReports = reportsData.values.where((r) => r['status'] == 'done').length;

        reportSummary['pending'] = pendingReports;
        reportSummary['done'] = doneReports;

        reportData = [
          PieChartSectionData(value: pendingReports.toDouble(), color: Colors.blue, title: 'Pending'),
          PieChartSectionData(value: doneReports.toDouble(), color: Colors.green, title: 'Done'),
        ];

        // Feedback data (still a List)
        int excellentFeedback = feedbackData.where((f) => f['rating'] == 5).length;
        int goodFeedback = feedbackData.where((f) => f['rating'] >= 3 && f['rating'] < 5).length;

        reportSummary['excellent'] = excellentFeedback;
        reportSummary['good'] = goodFeedback;

        this.feedbackData = [
          PieChartSectionData(value: excellentFeedback.toDouble(), color: Colors.orange, title: 'Excellent'),
          PieChartSectionData(value: goodFeedback.toDouble(), color: Colors.purple, title: 'Good'),
        ];

        // Truck status data (handle as Map)
        int activeTrucks = trucksData.values.where((t) => t['status'] == 'active').length;
        int inactiveTrucks = trucksData.values.where((t) => t['status'] == 'inactive').length;

        reportSummary['activeTrucks'] = activeTrucks;
        reportSummary['inactiveTrucks'] = inactiveTrucks;

        truckStatusData = [
          PieChartSectionData(value: activeTrucks.toDouble(), color: Colors.lightGreen, title: 'Active'),
          PieChartSectionData(value: inactiveTrucks.toDouble(), color: Colors.red, title: 'Inactive'),
        ];

        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Method to generate a simple report and display it
  void _generateMonthlyReport() {
    setState(() {
      _generatedReport = """
      Monthly Report:

      - Reports Status:
        * Pending: ${reportSummary['pending']}
        * Done: ${reportSummary['done']}

      - Feedback Ratings:
        * Excellent: ${reportSummary['excellent']}
        * Good: ${reportSummary['good']}

      - Truck Status:
        * Active: ${reportSummary['activeTrucks']}
        * Inactive: ${reportSummary['inactiveTrucks']}
      """;
    });
  }

  // Method to download the generated report as PDF
  Future<void> _downloadReportAsPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Monthly Report', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text(_generatedReport),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/monthly_report.pdf');

    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: const AdminDrawer(), // Reuse the same drawer
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Admin Dashboard Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Report Status Chart
            DashboardSection(
              title: 'Reports Status',
              child: DashboardPieChart(
                sections: reportData,
                chartTitle: 'Reports Status',
              ),
            ),
            // Feedback Ratings Chart
            DashboardSection(
              title: 'Feedback Ratings',
              child: DashboardPieChart(
                sections: feedbackData,
                chartTitle: 'Feedback Ratings',
              ),
            ),
            // Truck Status
            DashboardSection(
              title: 'Garbage Truck Status',
              child: DashboardPieChart(
                sections: truckStatusData,
                chartTitle: 'Garbage Truck Status',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateMonthlyReport,
              child: const Text('Generate Monthly Report'),
            ),
            if (_generatedReport.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Generated Report:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_generatedReport),
              ),
              ElevatedButton(
                onPressed: _downloadReportAsPdf,
                child: const Text('Download Report as PDF'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// Custom widget to display a section with a title
class DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardSection({
    required this.title,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

// Custom pie chart widget using FL Chart
class DashboardPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final String chartTitle;

  const DashboardPieChart({
    required this.sections,
    required this.chartTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Text(
            chartTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

