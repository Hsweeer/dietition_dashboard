import 'package:dietition_admin_panel/view/slidebar.dart';
import 'package:dietition_admin_panel/view/user_profile.dart';
import 'package:dietition_admin_panel/view/users_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controllers/tab_controller.dart';
import '../utils/app-colors.dart';
import 'Assign Diet plan.dart';
import 'Diet plan form.dart';
import 'Food item form.dart';
import 'Subscription plans.dart';
import 'master_plan.dart';


class AdminPanel extends StatelessWidget {
  final AdminTabController tabController = Get.put(AdminTabController());
  TimeOfDay selectedLunchTime = TimeOfDay(hour: 12, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(

            child: Stack(
              children: [
                // Main blue container
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Sidebar with menu items
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            SidebarLogo(),
                            Slidebar(),
                            SizedBox(height: 40),

                            UserProfile(),
                          ],
                        ),
                      ),
                    ),
                    // Main content area in a white rounded container
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Obx(() {
                          // Display content based on selected tab inside a white container
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _getTabContent(tabController.selectedTab.value),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to get content widget based on selected tab
  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return UsersScreen();
      case 1:
        return AssignDietPlanScreen();

      case 2:
        return FoodItemsMasterScreen( dietPlan: '', breakfastTime: selectedLunchTime, lunchTime: selectedLunchTime, dinnerTime: selectedLunchTime,);
        // return FoodItemsMasterScreen(clientUid: '', clientName: '', dietPlan: '', breakfastTime: '', lunchTime: '', dinnerTime: '', planExpiryDate: null, dietPlanExpiryDate: null,);

      case 3:
        return DietPlanScreen( dietPlan: '', breakfastTime: selectedLunchTime, lunchTime: selectedLunchTime, dinnerTime: selectedLunchTime, dietPlanExpiryDate: null, planExpiryDate: null, foodCategories: {},);
      case 4:
        return SubscriptionPlanScreen();
        case 5:
        return DietPlansScreen();

      default:
        return Container();
    }
  }
}
