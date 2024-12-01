import 'package:flutter/material.dart';
import '../utils/app-colors.dart';

class DietPlanScreen extends StatefulWidget {
  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final _dietPlanNameController = TextEditingController();
  String? _dietPlanType;
  String? _weeksDuration;
  String? _monthsDuration;

  // Define available durations for weekly and monthly plans
  final List<String> weeksOptions = ['1 week', '2 weeks', '4 weeks', '6 weeks', '8 weeks', '12 weeks'];
  final List<String> monthsOptions = ['1 month', '2 months', '3 months', '6 months', '12 months'];

  void _onDietPlanTypeChanged(String? value) {
    setState(() {
      _dietPlanType = value;
      _weeksDuration = null;
      _monthsDuration = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary
              ),
              child:Center(
                child: Text(
                  'Diet Plans',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ) ,
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Enter Diet Plan Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),

            // Diet Plan Name input inside a container for improved design
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                controller: _dietPlanNameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Platinum, Gold, Custom',
                  labelText: 'Diet Plan Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(Icons.fastfood, color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Diet Plan Type dropdown (Weekly or Monthly)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _dietPlanType,
                onChanged: _onDietPlanTypeChanged,
                items: [
                  DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                ],
                decoration: InputDecoration(
                  labelText: 'Diet Plan Type',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Show duration options based on the selected diet plan type
            if (_dietPlanType == 'Weekly') ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _weeksDuration,
                  onChanged: (value) => setState(() => _weeksDuration = value),
                  items: weeksOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'How many weeks?',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.access_time, color: AppColors.primary),
                  ),
                ),
              ),
            ] else if (_dietPlanType == 'Monthly') ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _monthsDuration,
                  onChanged: (value) => setState(() => _monthsDuration = value),
                  items: monthsOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'How many months?',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.access_alarm, color: AppColors.primary),
                  ),
                ),
              ),
            ],
            SizedBox(height: 30),

            // Save Button with improved styling
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement saving logic here
                  if (_dietPlanNameController.text.isNotEmpty && _dietPlanType != null &&
                      ((_dietPlanType == 'Weekly' && _weeksDuration != null) ||
                          (_dietPlanType == 'Monthly' && _monthsDuration != null))) {
                    // Save the diet plan
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Diet Plan Saved Successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                ),
                child: Text(
                  'Save Diet Plan',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Footer message or tips (for professionalism)
            Center(
              child: Text(
                'Make sure the plan duration fits your goal!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
