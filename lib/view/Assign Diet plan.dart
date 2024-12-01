import 'package:flutter/material.dart';

// Assuming you have a custom AppColors class with primary color
import '../utils/app-colors.dart';

class AssignDietPlanScreen extends StatefulWidget {
  @override
  _AssignDietPlanScreenState createState() => _AssignDietPlanScreenState();
}

class _AssignDietPlanScreenState extends State<AssignDietPlanScreen> {
  // List of clients who have made payment
  final List<String> clientsList = ['Client A', 'Client B', 'Client C'];

  // Track the selected client
  String? selectedClient;

  // List of diet plans
  final List<String> dietPlans = ['Platinum', 'Gold', 'Custom'];
  String? selectedDietPlan;

  // Date pickers and times
  TimeOfDay selectedBreakfastTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay selectedLunchTime = TimeOfDay(hour: 12, minute: 0);
  TimeOfDay selectedDinnerTime = TimeOfDay(hour: 19, minute: 0);

  DateTime? planExpiryDate;
  DateTime? dietPlanExpiryDate;

  // Function to show time picker for meals
  Future<void> _selectMealTime(BuildContext context, String mealType) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: mealType == 'Breakfast'
          ? selectedBreakfastTime
          : mealType == 'Lunch'
          ? selectedLunchTime
          : selectedDinnerTime,
    );
    if (newTime != null) {
      setState(() {
        if (mealType == 'Breakfast') {
          selectedBreakfastTime = newTime;
        } else if (mealType == 'Lunch') {
          selectedLunchTime = newTime;
        } else if (mealType == 'Dinner') {
          selectedDinnerTime = newTime;
        }
      });
    }
  }

  // Function to show date picker for expiry date
  Future<void> _selectExpiryDate(BuildContext context, String type) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (newDate != null) {
      setState(() {
        if (type == 'plan') {
          planExpiryDate = newDate;
        } else if (type == 'dietPlan') {
          dietPlanExpiryDate = newDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
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
                  'Assign Diet Plan',
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
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Client selection
                    Text('Select Client:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: EdgeInsets.only(top: 8, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Client', style: TextStyle(color: Colors.grey[600])),
                        value: selectedClient,
                        onChanged: (newValue) {
                          setState(() {
                            selectedClient = newValue;
                          });
                        },
                        isExpanded: true,
                        items: clientsList.map((client) {
                          return DropdownMenuItem<String>(
                            value: client,
                            child: Text(client, style: TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                        // Custom decoration for dropdown
                        dropdownColor: Colors.white,  // Dropdown background color
                        underline: SizedBox(),  // Removes the default underline
                      ),
                    ),
        
                    // Diet Plan selection
                    Text('Select Diet Plan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: EdgeInsets.only(top: 8, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Diet Plan', style: TextStyle(color: Colors.grey[600])),
                        value: selectedDietPlan,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDietPlan = newValue;
                          });
                        },
                        isExpanded: true,
                        items: dietPlans.map((plan) {
                          return DropdownMenuItem<String>(
                            value: plan,
                            child: Text(plan, style: TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                        // Custom decoration for dropdown
                        dropdownColor: Colors.white,  // Dropdown background color
                        underline: SizedBox(),  // Removes the default underline
                      ),
                    ),
        
                    // Meal Times selection
                    _buildMealTimePicker('Breakfast', selectedBreakfastTime),
                    _buildMealTimePicker('Lunch', selectedLunchTime),
                    _buildMealTimePicker('Dinner', selectedDinnerTime),
        
                    // Expiry Date pickers
                    _buildExpiryDatePicker('Diet Plan Expiry Date', dietPlanExpiryDate, 'dietPlan'),
                    _buildExpiryDatePicker('Plan Expiry Date', planExpiryDate, 'plan'),
        
                    SizedBox(height: 30),
        
                    // Assign Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,  // Use your custom primary color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (selectedDietPlan != null && selectedClient != null) {
                            // Show confirmation or navigate to next screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Diet Plan Assigned to $selectedClient')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a client and a diet plan')),
                            );
                          }
                        },
                        child: Text('Assign Diet Plan', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
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

  // Helper method to create time pickers for meals
  Widget _buildMealTimePicker(String mealType, TimeOfDay selectedTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$mealType Time:', style: TextStyle(fontSize: 16)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _selectMealTime(context, mealType),
              child: Text('Select $mealType Time (${selectedTime.format(context)})'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create expiry date pickers
  Widget _buildExpiryDatePicker(String label, DateTime? expiryDate, String type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _selectExpiryDate(context, type),
              child: Text(
                expiryDate != null
                    ? '${expiryDate.toLocal()}'
                    : 'Select Expiry Date',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}