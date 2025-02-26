import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/app-colors.dart';
import 'Food item form.dart';
import 'master_plan.dart';

class DietPlanScreen extends StatefulWidget {
  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;
  final int dietPlanDays;
  final Map<String, List<Map<String, dynamic>>> foodCategories;

  const DietPlanScreen({
    Key? key,
    required this.breakfastTime,
    required this.lunchTime,
    required this.dinnerTime,
    required this.dietPlanDays,
    required this.foodCategories,
  }) : super(key: key);

  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final FoodItemsMasterController controller = Get.put(FoodItemsMasterController());

  final _dietPlanNameController = TextEditingController();
  final _dietPlanCostController = TextEditingController();
  String? _dietPlanType;
  String? _weeksDuration;
  String? _monthsDuration;
  bool _isFreePlan = false;
  late TimeOfDay _breakfastTime;
  late TimeOfDay _lunchTime;
  late TimeOfDay _dinnerTime;
  late int _dietPlanDays;

  @override
  void initState() {
    super.initState();
    _breakfastTime = widget.breakfastTime;
    _lunchTime = widget.lunchTime;
    _dinnerTime = widget.dinnerTime;
    _dietPlanDays = widget.dietPlanDays;
  }
  void _onDietPlanTypeChanged(String? value) {
    setState(() {
      _dietPlanType = value;
      _weeksDuration = null;
      _monthsDuration = null;
      _dietPlanDays = 0; // Reset days when the type changes
    });
  }


  Future<void> _selectTime(BuildContext context, String mealType) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: mealType == 'Breakfast'
          ? _breakfastTime
          : mealType == 'Lunch'
          ? _lunchTime
          : _dinnerTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (mealType == 'Breakfast') {
          _breakfastTime = pickedTime;
        } else if (mealType == 'Lunch') {
          _lunchTime = pickedTime;
        } else {
          _dinnerTime = pickedTime;
        }
      });
    }
  }

  final List<String> weeksOptions = [
    '1 week',
    '2 weeks',
    '4 weeks',
    '6 weeks',
    '8 weeks',
    '12 weeks'
  ];
  final List<String> monthsOptions = [
    '1 month',
    '2 months',
    '3 months',
    '6 months',
    '12 months'
  ];

  // void _onDietPlanTypeChanged(String? value) {
  //   setState(() {
  //     _dietPlanType = value;
  //     _weeksDuration = null;
  //     _monthsDuration = null;
  //   });
  // }

  void _deleteCategoryItem(String category, int index) {
    setState(() {
      widget.foodCategories[category]?.removeAt(index);
    });
  }

  void _editCategoryItem(String category, int index, String newName) {
    setState(() {
      widget.foodCategories[category]?[index]['name'] = newName;
    });
  }

  void _editDietPlanDays(BuildContext context) {
    TextEditingController daysController =
    TextEditingController(text: _dietPlanDays.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Diet Plan Days'),
          content: TextField(
            controller: daysController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Plan Duration (Days)',
              hintText: 'Enter the number of days',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _dietPlanDays = int.tryParse(daysController.text) ?? _dietPlanDays;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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

            // Diet Plan Name
            Text(
              'Enter Diet Plan Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10),
            _buildInputField(
              controller: _dietPlanNameController,
              hintText: 'e.g., Platinum, Gold, Custom',
              labelText: 'Diet Plan Name',
              icon: Icons.fastfood,
            ),
            SizedBox(height: 20),

            // Diet Plan Cost
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

            // Diet Plan Type
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

            // Plan Duration Options
            if (_dietPlanType == 'Weekly')
              _buildDropdownField(
                value: _weeksDuration,
                labelText: 'How many weeks?',
                icon: Icons.access_time,
                items: weeksOptions.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _weeksDuration = value;
                    _dietPlanDays = int.parse(value!.split(' ')[0]) * 7; // Calculate days
                  });
                },
              )
            else if (_dietPlanType == 'Monthly')
              _buildDropdownField(
                value: _monthsDuration,
                labelText: 'How many months?',
                icon: Icons.access_alarm,
                items: monthsOptions.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _monthsDuration = value;
                    _dietPlanDays = int.parse(value!.split(' ')[0]) * 30; // Calculate days
                  });
                },
              ),

            // if (_dietPlanType == 'Weekly')
            //   _buildDropdownField(
            //     value: _weeksDuration,
            //     labelText: 'How many weeks?',
            //     icon: Icons.access_time,
            //     items: weeksOptions.map((option) {
            //       return DropdownMenuItem(value: option, child: Text(option));
            //     }).toList(),
            //     onChanged: (value) => setState(() => _weeksDuration = value),
            //   )
            // else if (_dietPlanType == 'Monthly')
            //   _buildDropdownField(
            //     value: _monthsDuration,
            //     labelText: 'How many months?',
            //     icon: Icons.access_alarm,
            //     items: monthsOptions.map((option) {
            //       return DropdownMenuItem(value: option, child: Text(option));
            //     }).toList(),
            //     onChanged: (value) => setState(() => _monthsDuration = value),
            //   ),
            SizedBox(height: 30),

            // Editable Meal Times and Plan Duration
            Text(
              'Meal Times and Duration:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10),
            _buildEditableRow(
              context,
              label: 'Breakfast Time:',
              value: _breakfastTime.format(context),
              onEdit: () => _selectTime(context, 'Breakfast'),
            ),
            SizedBox(height: 10),
            _buildEditableRow(
              context,
              label: 'Lunch Time:',
              value: _lunchTime.format(context),
              onEdit: () => _selectTime(context, 'Lunch'),
            ),
            SizedBox(height: 10),
            _buildEditableRow(
              context,
              label: 'Dinner Time:',
              value: _dinnerTime.format(context),
              onEdit: () => _selectTime(context, 'Dinner'),
            ),
            SizedBox(height: 10),
            _buildEditableRow(
              context,
              label: 'Plan Duration (Days):',
              value: '$_dietPlanDays days',
              onEdit: () => _editDietPlanDays(context),
            ),
            SizedBox(height: 20.h,),
            Text(
              'Food Items:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            ...controller.foodCategories.entries.map((entry) {
              return FoodCategoryWidget(
                category: entry.key,
                items: entry.value,
                previousItems: controller.previousEntries[entry.key] ?? RxList<Map<String, dynamic>>(),
                onAddItem: () => controller.addFoodItem(entry.key),
                onRemoveItem: (index) => controller.removeFoodItem(entry.key, index),
                onUpdateItem: (index, field, value) =>
                    controller.updateFoodItem(entry.key, index, field, value),
                onReuseItem: (item) => controller.reusePreviousItem(entry.key, item),
                onSaveNewItem: (item) => controller.saveToFirebase(entry.key, item),
              );
            }).toList(),

            SizedBox(height: 30),

            // Food Categories Section
            Text(
              'Food Categories:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10),
            if (widget.foodCategories.isEmpty)
              Center(
                child: Text(
                  'No food categories available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.foodCategories.length,
                itemBuilder: (context, categoryIndex) {
                  String category =
                  widget.foodCategories.keys.elementAt(categoryIndex);
                  List<Map<String, dynamic>> items =
                      widget.foodCategories[category] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...items.asMap().entries.map((entry) {
                        int itemIndex = entry.key;
                        Map<String, dynamic> item = entry.value;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(item['name']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    TextEditingController editController =
                                    TextEditingController(
                                        text: item['name']);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit Item'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter new name',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _editCategoryItem(
                                                    category,
                                                    itemIndex,
                                                    editController.text);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategoryItem(
                                      category, itemIndex),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
            SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_dietPlanNameController.text.isNotEmpty &&
                      _dietPlanType != null &&
                      ((_dietPlanType == 'Weekly' && _weeksDuration != null) ||
                          (_dietPlanType == 'Monthly' && _monthsDuration != null))) {
                    try {
                      final planCost = _dietPlanCostController.text.isEmpty
                          ? '0'
                          : _dietPlanCostController.text;

                      final masterDietPlan = {
                        'mealTimes': {
                          'breakfast': _breakfastTime.format(context),
                          'lunch': _lunchTime.format(context),
                          'dinner': _dinnerTime.format(context),
                        },
                        'durationInDays': _dietPlanDays,
                        'foodCategories': widget.foodCategories,
                        'additionalPlanDetails': {
                          'dietPlanName': _dietPlanNameController.text,
                          'cost': planCost,
                          'type': _dietPlanType,
                          'isFreePlan': _isFreePlan,
                          'weeksDuration': _dietPlanType == 'Weekly' ? _weeksDuration : null,
                          'monthsDuration': _dietPlanType == 'Monthly' ? _monthsDuration : null,
                        },
                      };

                      await FirebaseFirestore.instance
                          .collection('MasterDietPlans')
                          .add(masterDietPlan);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Master Diet Plan saved successfully!')),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DietPlansScreenmaster()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving diet plan: $e')),
                      );
                    }
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
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(BuildContext context,
      {required String label, required String value, required VoidCallback onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primary),
              onPressed: onEdit,
            ),
          ],
        ),
      ],
    );
  }

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
