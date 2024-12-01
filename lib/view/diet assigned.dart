import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import '../controllers/food controller.dart';
import '../utils/app-colors.dart';

class DietAssignmentScreen extends StatelessWidget {
  final DietPlanController controller = Get.put(DietPlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body:

      Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client List
                  Text("Clients Who Paid", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  _buildClientList(),

                  SizedBox(height: 16),

                  // Select Diet Plan Template
                  Text("Select Diet Plan Template", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildDietPlanTemplateList(),

                  SizedBox(height: 16),

                  // Editable Meal Categories with Time Picker
                  _buildEditableCategoryFields(),

                  SizedBox(height: 16),

                  // Expiry Information and Notifications
                  _buildExpiryDetails(),

                  SizedBox(height: 16),

                  // Submit Button for Saving Assignments
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to display the client list
  Widget _buildClientList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,  // You can replace this with actual client data
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Client ${index + 1}"),
            subtitle: Text("Payment Status: Paid"),
            onTap: () {
              // On client tap, open diet plan template screen
            },
          );
        },
      ),
    );
  }

  // Method to display diet plan templates
  Widget _buildDietPlanTemplateList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
      ),
      child: DropdownButtonFormField<String>(
        value: controller.dietPlanType.value,
        onChanged: (value) => controller.dietPlanType.value = value!,
        items: ['Weekly', 'Monthly'].map((plan) {
          return DropdownMenuItem(value: plan, child: Text(plan));
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Select Diet Plan Template',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  // Method to build editable fields for meals
  Widget _buildEditableCategoryFields() {
    return Obx(() {
      return Column(
        children: controller.selectedCategories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quantity Input Field
                  Container(
                    width: 120,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                  // Time Picker for Meal
                  ElevatedButton(
                    onPressed: () => _selectMealTime(entry.key),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text('Select Time', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      );
    });
  }

  // Method to select meal time using a time picker
  void _selectMealTime(String category) {
    DatePicker.showTimePicker(
      Get.context!,
      showTitleActions: true,
      onConfirm: (time) {
        // Store the selected time for the meal category
        print('$category Time Selected: $time');
      },
    );
  }

  // Method to display expiry date and plan details
  Widget _buildExpiryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Diet Plan Expiry", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Entire Plan Expiry Date
            Text("Entire Plan Expiry: 24th Dec 2024", style: TextStyle(fontSize: 14)),
            ElevatedButton(
              onPressed: () {
                // Handle notifications for diet plan expiry
              },
              child: Text("Set Notification", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Diet Plan Weekly Expiry
            Text("Weekly Diet Plan Expiry: 1st Dec 2024", style: TextStyle(fontSize: 14)),
            ElevatedButton(
              onPressed: () {
                // Handle notifications for weekly expiry
              },
              child: Text("Set Notification", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  // Method to handle submit action
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // Logic to assign diet plan to the client
        print("Diet Plan Assigned to Client");
      },
      child: Center(
        child: Text(
          'Assign Diet Plan',
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
