import 'package:flutter/material.dart';

// A custom widget for dynamic text fields
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isRequired;
  final TextInputType inputType;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isRequired = false,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                labelText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.star,
                    color: Colors.red,
                    size: 14,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: 'Enter your $labelText',
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.5), // Border color when not focused
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.purple, // Border color when focused
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

