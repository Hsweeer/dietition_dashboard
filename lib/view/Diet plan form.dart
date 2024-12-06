import 'package:flutter/material.dart';
import '../utils/app-colors.dart';

class DietPlanScreen extends StatefulWidget {
  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final _dietPlanNameController = TextEditingController();
  final _dietPlanCostController = TextEditingController();
  String? _dietPlanType;
  String? _weeksDuration;
  String? _monthsDuration;
  bool _isFreePlan = false;

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
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  'Diet Plans',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
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

            // Diet Plan Name input
            _buildInputField(
              controller: _dietPlanNameController,
              hintText: 'e.g., Platinum, Gold, Custom',
              labelText: 'Diet Plan Name',
              icon: Icons.fastfood,
            ),

            SizedBox(height: 20),

            // Diet Plan Cost input
            _buildInputField(
              controller: _dietPlanCostController,
              hintText: 'e.g., 0 for Free, 100, 200',
              labelText: 'Cost (PKR)',
              icon: Icons.attach_money,
              onChanged: (value) {
                setState(() {
                  _isFreePlan = value == '0';
                });
              },
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            // Diet Plan Type dropdown
            _buildDropdownField(
              value: _dietPlanType,
              labelText: 'Diet Plan Type',
              icon: Icons.calendar_today,
              items: [
                DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
              ],
              onChanged: _onDietPlanTypeChanged,
            ),

            SizedBox(height: 20),

            // Show duration options based on the selected diet plan type
            if (_dietPlanType == 'Weekly')
              _buildDropdownField(
                value: _weeksDuration,
                labelText: 'How many weeks?',
                icon: Icons.access_time,
                items: weeksOptions.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) => setState(() => _weeksDuration = value),
              )
            else if (_dietPlanType == 'Monthly')
              _buildDropdownField(
                value: _monthsDuration,
                labelText: 'How many months?',
                icon: Icons.access_alarm,
                items: monthsOptions.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) => setState(() => _monthsDuration = value),
              ),

            SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_dietPlanNameController.text.isNotEmpty &&
                      _dietPlanType != null &&
                      ((_dietPlanType == 'Weekly' && _weeksDuration != null) ||
                          (_dietPlanType == 'Monthly' && _monthsDuration != null))) {
                    final planCost = _dietPlanCostController.text.isEmpty
                        ? '0'
                        : _dietPlanCostController.text;
                    final expiry = _isFreePlan ? _weeksDuration : 'N/A';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Diet Plan Saved Successfully! Cost: $planCost, Expiry: $expiry'),
                      ),
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Footer message or tips
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

  // Helper function to build a text input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData icon,
    void Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }

  // Helper function to build a dropdown field
  Widget _buildDropdownField({
    required String? value,
    required String labelText,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}
