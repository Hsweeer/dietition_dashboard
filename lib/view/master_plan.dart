import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DietPlansScreenmaster extends StatefulWidget {
  @override
  _DietPlansScreenmasterState createState() => _DietPlansScreenmasterState();
}

class _DietPlansScreenmasterState extends State<DietPlansScreenmaster> {
  static const Color primary = Color(0xff91b526);
  static const Color secondary = Colors.white;
  DateTime? selectedWeekStartDate; // Selected start date for the week
  DateTime? selectedMealDate; // Selected date for food items
  List<Map<String, dynamic>> foodItems = []; // Store fetched food items
  String? selectedDietPlanId;
  Map<String, dynamic>? selectedDietPlan;
  int? selectedWeek;
  Map<int, Map<String, dynamic>> assignedWeeks = {};
  List<String> selectedUserIds = [];
  DateTime? startDate;
  DateTime? endDate;
  bool isPlanVisible = true;
  List<Map<String, dynamic>> foodItemsByCategory = []; // Declare and initialize
  late Future<List<Map<String, dynamic>>> _dietPlans;
  late Future<List<Map<String, dynamic>>> _users;

  @override
  void initState() {
    super.initState();
    _dietPlans = fetchDietPlans();
    _users = fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchDietPlans() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('MasterDietPlans').get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      print('Error fetching diet plans: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  int calculateWeeks() {
    if (selectedDietPlan == null) return 0;

    final planType = selectedDietPlan?['additionalPlanDetails']['type'];
    final duration =
        selectedDietPlan?['additionalPlanDetails']['weeksDuration'] ??
            selectedDietPlan?['additionalPlanDetails']['monthsDuration'];

    if (planType == 'Weekly') {
      return int.tryParse(duration?.split(' ')[0] ?? '0') ?? 0;
    } else if (planType == 'Monthly') {
      final numMonths = int.tryParse(duration?.split(' ')[0] ?? '0') ?? 0;
      return numMonths * 4;
    }
    return 0;
  }
  void showFoodSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to manage dialog state
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Food Items",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    Divider(color: primary),
                    Expanded(
                      child: ListView(
                        children: foodItemsByCategory.map<Widget>((category) {
                          return renderFoodItemsByCategory(
                            category,
                            setDialogState, // Pass the dialog-specific setState
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: secondary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> renderWeeks() {
    final totalWeeks = calculateWeeks();
    if (totalWeeks == 0) return [];

    return List.generate(totalWeeks, (index) {
      final weekNum = index + 1;
      final isSelected = selectedWeek == weekNum; // Check if this week is selected

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week card
          GestureDetector(
            onTap: () async {
              final pickedDate = await pickStartDate(context);
              if (pickedDate != null) {
                setState(() {
                  selectedWeek = weekNum; // Set the current selected week
                  selectedWeekStartDate = pickedDate;
                  selectedMealDate = null; // Reset the meal date selection
                  foodItemsByCategory = []; // Clear previously fetched food items
                });
                fetchFoodItems();
                // Fetch food items for the newly selected week

              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isSelected ? primary.withOpacity(0.2) : secondary,
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Week $weekNum",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? primary : primary,
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? primary : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Render week dates if selected
          if (isSelected && selectedWeekStartDate != null)
            ...renderWeekDates(),

          // Render food items only for the selected week


        ],
      );
    });
  }

// Render the 7 days of the selected week
  List<Widget> renderWeekDates() {
    final weekDates = List.generate(7, (index) {
      return selectedWeekStartDate!.add(Duration(days: index));
    });

    return [
      SizedBox(height: 8),
      Text(
        "Select a date for Week $selectedWeek",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
      ),
      SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: weekDates.map((date) {
          final isSelected = selectedMealDate == date;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMealDate = date;
                fetchFoodItems(); // Fetch food items for this date
              });
              showFoodSelectionDialog(context); // Show the dialog

            },
            child: Chip(
              label: Text(
                DateFormat('EEE, MMM d').format(date),
                style: TextStyle(color: isSelected ? secondary : primary),
              ),
              backgroundColor: isSelected ? primary : secondary,
              side: BorderSide(color: primary),
            ),
          );
        }).toList(),
      ),
      Divider(),
    ];
  }
// Fetch food items from the Firestore
  Future<void> fetchFoodItems() async {
    // Get all documents (e.g., Breakfast, Lunch) from the foodItems collection
    final querySnapshot = await FirebaseFirestore.instance.collection('foodItems').get();

    setState(() {
      // Process each document and its food items
      foodItemsByCategory = querySnapshot.docs.map((doc) {
        return {
          'category': doc.id, // Document name (e.g., Breakfast, Dinner)
          'items': doc.data()['items'].map((item) {
            return {
              'name': item['name'] ?? 'Unknown Item',
              'calories': item['calories']?.isNotEmpty == true ? item['calories'] : 'N/A',
              'vegetarian': item['vegetarian'] ?? 'Unknown',
              'images': item['images'] ?? '',
              'id': item['id'] ?? '', // Unique identifier if available
            };
          }).toList(),
        };
      }).toList();
    });
  }

// Render food items for the selected date
  Future<void> assignDietPlanToUsers() async {
    if (selectedDietPlan == null ||
        selectedUserIds.isEmpty ||
        selectedWeek == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all required fields.')),
      );
      return;
    }

    try {
      final totalWeeks = calculateWeeks();

      // Prepare assignment details
      final assignmentDetails = {
        'dietPlanId': selectedDietPlanId,
        'dietPlanDetails': selectedDietPlan,
        'week': selectedWeek,
        'date': selectedMealDate?.toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'assignedDate': DateTime.now().toIso8601String(),
      };

      // Filter only the selected food items by category
      final selectedFoodItemsByCategory = foodItemsByCategory.map((category) {
        final selectedItems = category['items']
            .where((item) {
          // Use the unique key (category + name) for matching
          final uniqueKey = '${category['category']}-${item['name']}';
          return selectedFoodItemIds.contains(uniqueKey);
        })
            .map((item) => {
          'name': item['name'],
          'calories': item['calories'],
          'vegetarian': item['vegetarian'],
          'images': item['images'],
        })
            .toList();

        if (selectedItems.isNotEmpty) {
          return {
            'category': category['category'], // Ensure category is preserved
            'items': selectedItems, // Include only selected items
          };
        } else {
          return null; // Exclude categories with no selected items
        }
      }).where((category) => category != null).toList();

      // Assign the diet plan and selected food items to each user
      for (var userId in selectedUserIds) {
        if (userId.isEmpty) {
          print('Skipping invalid user ID: $userId');
          continue;
        }

        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'assignedDietPlan': assignmentDetails,
          'totalWeeksOpted': totalWeeks,
          'assignedWeeks': FieldValue.arrayUnion([selectedWeek]),
          'selectedFoodItems': selectedFoodItemsByCategory, // Store selected food items
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diet Plan assigned successfully!')),
      );

      setState(() {
        selectedUserIds.clear();
        startDate = null;
        endDate = null;
        selectedWeek = null;
        selectedFoodItemIds.clear(); // Reset selected food items
      });
    } catch (e) {
      print('Error assigning diet plan to users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to assign diet plan.')),
      );
    }
  }

// Updated food item selection logic
  Set<String> selectedFoodItemIds = {}; // Track selected food item IDs

  Widget renderFoodItemCheckbox(Map<String, dynamic> foodItem, String category, Function setDialogState) {
    final uniqueKey = '$category-${foodItem['name']}';

    return CheckboxListTile(
      title: Text(foodItem['name'] ?? 'Unknown Item'),
      subtitle: Text('Calories: ${foodItem['calories']}, Vegetarian: ${foodItem['vegetarian']}'),
      value: selectedFoodItemIds.contains(uniqueKey),
      onChanged: (isChecked) {
        setDialogState(() {
          if (isChecked ?? false) {
            selectedFoodItemIds.add(uniqueKey);
          } else {
            selectedFoodItemIds.remove(uniqueKey);
          }
        });
      },
    );
  }
// Updated rendering of food items to allow individual selection
  Widget renderFoodItemsByCategory(Map<String, dynamic> category, Function setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category['category'] ?? 'Unknown Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
        ),
        ...category['items'].map<Widget>((item) {
          return renderFoodItemCheckbox(item, category['category'], setDialogState);
        }).toList(),
        Divider(color: Colors.grey),
      ],
    );
  }
  Future<DateTime?> pickStartDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    // Return the selected date to the caller
    return selected;
  }


  Future<void> pickEndDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        endDate = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Diet Plans to Users', style: TextStyle(color: secondary)),
        backgroundColor: primary,
        centerTitle: true,
      ),
      backgroundColor: secondary,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select Users',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _users,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(color: primary));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Users Found.'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildUserCard(snapshot.data![index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 2, color: primary),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select Diet Plan',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _dietPlans,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(color: primary));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Diet Plans Found.'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildDietPlanCard(snapshot.data![index]);
                        },
                      );
                    },
                  ),
                ),
                if (selectedDietPlan != null)
                  SwitchListTile(
                    title: Text(
                      "Plan Visibility",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: primary),
                    ),
                    value: isPlanVisible,
                    activeColor: primary,
                    onChanged: (value) {
                      setState(() {
                        isPlanVisible = value;
                      });

                      FirebaseFirestore.instance
                          .collection('MasterDietPlans')
                          .doc(selectedDietPlanId)
                          .update({'visible': value});
                    },
                  ),
              ],
            ),
          ),
          VerticalDivider(width: 2, color: primary),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                if (selectedDietPlan != null)
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Select Week',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primary),
                          ),
                        ),
                        Expanded(child: ListView(children: renderWeeks())),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                            ),
                            onPressed: () => pickEndDate(context),
                            child: Text(
                              'Select End Date',
                              style: TextStyle(fontSize: 18, color: secondary),
                            ),
                          ),
                        ),
                        if (startDate != null && endDate != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Start Date: ${dateFormatter.format(startDate!)}\nEnd Date: ${dateFormatter.format(endDate!)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: EdgeInsets.all(12),
                          ),
                          onPressed: assignDietPlanToUsers,
                          child: Text(
                            'Assign Diet Plan',
                            style: TextStyle(fontSize: 18, color: secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (selectedDietPlan == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Please select a diet plan first',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDietPlanCard(Map<String, dynamic> dietPlan) {
    final isSelected = selectedDietPlanId == dietPlan['id'];
    final price = dietPlan['additionalPlanDetails']['cost'] ?? 'Free';
    final isFree = price == '0';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDietPlanId = dietPlan['id'];
          selectedDietPlan = dietPlan;
          isPlanVisible = dietPlan['visible'] ?? true;

        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isSelected ? primary.withOpacity(0.1) : secondary,
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dietPlan['additionalPlanDetails']['dietPlanName'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primary : primary,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type: ${dietPlan['additionalPlanDetails']['type']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isFree ? Colors.green : Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isFree ? 'Free' : 'PKR $price',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text(
                      "Meal Times",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
                    ),
                    Text("Breakfast: ${dietPlan['mealTimes']['breakfast']}"),
                    Text("Lunch: ${dietPlan['mealTimes']['lunch']}"),
                    Text("Dinner: ${dietPlan['mealTimes']['dinner']}"),
                    Divider(),
                    Text(
                      "Food Categories",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
                    ),
                    ...renderFoodCategories(dietPlan['foodCategories']),
                  ],
                ),
              if (isSelected) ...[
                Divider(),
                Text(
                  "Plan Visibility: ${isPlanVisible ? 'Visible' : 'Not Visible'}",
                  style: TextStyle(fontSize: 14, color: primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> renderFoodCategories(Map<String, dynamic> foodCategories) {
    return foodCategories.entries.map((entry) {
      final categoryName = entry.key;
      final items = entry.value as List<dynamic>;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary),
          ),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "${item['name']} - ${item['calories']} cal (${item['vegetarian']})",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            );
          }).toList(),
        ],
      );
    }).toList();
  }
  Widget buildUserCard(Map<String, dynamic> user) {
    final int totalWeeksOpted = user['totalWeeksOpted'] ?? 0;
    final List<int> assignedWeeks = List<int>.from(user['assignedWeeks'] ?? []);
    final int pendingWeeks = totalWeeksOpted - assignedWeeks.length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primary,
          child: Icon(Icons.person, color: secondary),
        ),
        title: Text(
          user['name'] ?? 'No Name',
          style: TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user['email'] ?? 'No Email'}'),
            Text('Phone: ${user['phone'] ?? 'N/A'}'),
            Text('Total Weeks Opted: $totalWeeksOpted'),
            if (pendingWeeks > 0)
              Text(
                '$pendingWeeks week(s) pending',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            if (assignedWeeks.isNotEmpty)
              Text(
                'Assigned Weeks: ${assignedWeeks.join(', ')}',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: Checkbox(
          value: selectedUserIds.contains(user['id']),
          activeColor: primary,
          onChanged: (isChecked) {
            setState(() {
              if (isChecked ?? false) {
                selectedUserIds.add(user['id']);
              } else {
                selectedUserIds.remove(user['id']);
              }
            });
          },
        ),
      ),
    );
  }
}
