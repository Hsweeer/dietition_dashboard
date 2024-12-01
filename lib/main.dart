import 'package:dietition_admin_panel/controllers/food%20controller.dart';
import 'package:dietition_admin_panel/view/Admin_panel.dart';
import 'package:dietition_admin_panel/view/Diet%20plan%20form.dart';
import 'package:dietition_admin_panel/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart'; // Import Firebase Core


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Firebase is initialized before runApp
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.web
  // ); // Initialize Firebase

Get.put(DietPlanController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // Adjust the design size according to your design
      minTextAdapt: true,
      splitScreenMode: true, // Ensures better layout on web
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: AdminPanel(),
        );
      },
    );
  }
}
