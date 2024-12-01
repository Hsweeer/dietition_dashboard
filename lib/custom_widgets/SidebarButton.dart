// SidebarButton Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SidebarButton({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontSize: 16.sp, color: Colors.white)),
      onTap: onTap,
    );
  }
}
