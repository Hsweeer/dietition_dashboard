import 'package:flutter/material.dart';
import '../utils/app-colors.dart';
import 'Food item form.dart';

class AssignDietPlanScreen extends StatefulWidget {
  @override
  _AssignDietPlanScreenState createState() => _AssignDietPlanScreenState();
}

class _AssignDietPlanScreenState extends State<AssignDietPlanScreen> {
  // List of diet plans
  final List<String> dietPlans = ['Platinum', 'Gold', 'Custom'];
  String? selectedDietPlan;

  // Time pickers
  TimeOfDay selectedBreakfastTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay selectedLunchTime = TimeOfDay(hour: 12, minute: 0);
  TimeOfDay selectedDinnerTime = TimeOfDay(hour: 19, minute: 0);

  // Controller for diet plan availability days
  final TextEditingController daysController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  'Assign Diet Plan',
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealTimePicker('Breakfast', selectedBreakfastTime),
                  _buildMealTimePicker('Lunch', selectedLunchTime),
                  _buildMealTimePicker('Dinner', selectedDinnerTime),
                  // Input for Diet Plan Availability Days
                  Text('Enter Days of Availability:', style: TextStyle(fontSize: 16)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.only(top: 8, bottom: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: TextField(
                      controller: daysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter days (e.g., 30)',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Assign Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if ( daysController.text.isNotEmpty) {
                          final int days = int.tryParse(daysController.text) ?? 0;
                          if (days > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodItemsMasterScreen(
                                  breakfastTime: selectedBreakfastTime,
                                  lunchTime: selectedLunchTime,
                                  dinnerTime: selectedDinnerTime,
                                  dietPlanDays: days,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a valid number of days.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select a diet plan and enter availability days.')),
                          );
                        }
                      },
                      child: Text('Select Food for the Client',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
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
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
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
