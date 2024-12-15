import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Images_const/images_const.dart';
import '../controllers/tab_controller.dart';
import '../main.dart';

class Slidebar extends StatelessWidget {
  final AdminTabController tabController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SidebarButton(label: 'User', icon: Icons.person, index: 0),
        _SidebarButton(label: 'Assign Diet Plan', icon: Icons.add, index: 1),
        _SidebarButton(label: 'Food Items', icon: Icons.add, index: 2),
        _SidebarButton(label: 'Create Diet Plan', icon: Icons.add, index: 3),
        _SidebarButton(label: 'Subscription Plans', icon: Icons.unsubscribe, index: 4),
        _SidebarButton(label: 'DietPlansScreen', icon: Icons.history, index: 5),
        _SidebarButton(label: 'Settings', icon: Icons.settings, index: 6),
      ],
    );
  }
}

// Sidebar button widget
class _SidebarButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final int index;

  const _SidebarButton({required this.label, required this.icon, required this.index});

  @override
  Widget build(BuildContext context) {
    final AdminTabController tabController = Get.find();

    return Obx(() {
      bool isSelected = tabController.selectedTab.value == index;

      return GestureDetector(
        onTap: () => tabController.changeTab(index),
        child: Stack(
          children: [
            // Indicator for the selected tab
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(icon, color: isSelected ? Colors.white : Colors.white.withOpacity(0.7)),
                  SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // Side indicator for selected tab
            if (isSelected)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
class SidebarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
        child: Row(
          children: [
            SizedBox(width: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(logo,color:Colors.white,height: 100,width: 100,),
              ],
            ),
            SizedBox(height: 30.h,),
            // Text(
            //   '    My Pocket Muslim ',
            //   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
