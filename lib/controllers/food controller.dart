import 'package:get/get.dart';



class DietPlanController extends GetxController {
  // Reactive variables
  var dietPlanType = 'Weekly'.obs;  // Selected diet plan template
  var selectedCategories = {
    'Breakfast': {'quantity': 0, 'time': '08:00 AM'},
    'Lunch': {'quantity': 0, 'time': '01:00 PM'},
    'Snacks': {'quantity': 0, 'time': '04:00 PM'},
    'Dinner': {'quantity': 0, 'time': '07:00 PM'},
  }.obs;  // A map of categories with quantity and time

  // Method to update the meal time for a specific category
  void updateMealTime(String category, String newTime) {
    selectedCategories[category]!['time'] = newTime;
    update();  // This updates the reactive variable to notify listeners
  }

  // Method to update the quantity for a specific category
  void updateMealQuantity(String category, int newQuantity) {
    selectedCategories[category]!['quantity'] = newQuantity;
    update();  // Update the UI when the quantity changes
  }

  // Method to update the diet plan template
  void updateDietPlanType(String newPlan) {
    dietPlanType.value = newPlan;
  }

  // Method to send notification when a meal time is approaching
  void sendMealTimeNotification(String category) {
    // Here, you can use Firebase Cloud Messaging or local notifications to send reminders
    print("Reminder: Your $category time is approaching.");
  }

  // Method to send expiry notifications for the diet plan
  void sendExpiryNotification() {
    // Logic for expiry notifications, either for weekly or overall diet plan expiry
    print("Your diet plan is about to expire.");
  }
}
