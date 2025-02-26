import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  static const Color primary = Color(0xff91b526);
  static const Color secondary = Colors.white;

  late Future<Map<String, dynamic>> _dashboardMetrics;

  @override
  void initState() {
    super.initState();
    _dashboardMetrics = fetchDashboardMetrics();
  }

  Future<Map<String, dynamic>> fetchDashboardMetrics() async {
    try {
      final foodItemsSnapshot =
      await FirebaseFirestore.instance.collection('FoodItems').get();
      final dietPlansSnapshot =
      await FirebaseFirestore.instance.collection('MasterDietPlans').get();
      final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      final activePlans = dietPlansSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['visible'] == true;
      }).length;

      final disabledPlans = dietPlansSnapshot.size - activePlans;

      final clientsAssigned = usersSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['assignedDietPlan'] != null;
      }).length;

      return {
        'totalFoodItems': foodItemsSnapshot.size,
        'totalDietPlans': dietPlansSnapshot.size,
        'clientsAssigned': clientsAssigned,
        'activePlans': activePlans,
        'disabledPlans': disabledPlans,
      };
    } catch (e) {
      print('Error fetching metrics: $e');
      return {};
    }
  }

  void generateReport(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generating Report...')),
      );

      // Simulate report generation (replace with actual report generation logic)
      await Future.delayed(Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report generated successfully!')),
      );
    } catch (e) {
      print('Error generating report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating report.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard', style: TextStyle(color: secondary)),
        backgroundColor: primary,
        centerTitle: true,
      ),
      backgroundColor: secondary,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardMetrics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primary));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Unable to fetch metrics.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final metrics = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildMetricCard(
                  title: 'Total Food Items in Master',
                  value: metrics['totalFoodItems'].toString(),
                  icon: Icons.fastfood,
                  context: context,
                ),
                buildMetricCard(
                  title: 'Total Diet Plans Created',
                  value: metrics['totalDietPlans'].toString(),
                  icon: Icons.local_dining,
                  context: context,
                ),
                buildMetricCard(
                  title: 'Clients Assigned to Diet Plans',
                  value: metrics['clientsAssigned'].toString(),
                  icon: Icons.people,
                  context: context,
                ),
                buildMetricCard(
                  title: 'Active Diet Plans',
                  value: metrics['activePlans'].toString(),
                  icon: Icons.check_circle,
                  context: context,
                ),
                buildMetricCard(
                  title: 'Disabled Diet Plans',
                  value: metrics['disabledPlans'].toString(),
                  icon: Icons.block,
                  context: context,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () => generateReport(context),
                    child: Text(
                      'Generate Report',
                      style: TextStyle(fontSize: 18, color: secondary),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required BuildContext context,
  }) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: primary),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
