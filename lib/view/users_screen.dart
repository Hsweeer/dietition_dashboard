import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

// class User {
//   final String name;
//   final String userId;
//   final String email;
//   final String gender;
//   final String phone;
//   String status;
//   String subscriptionType;
//   bool dietPlanAccess;
//   bool loginEnabled;
//   Map<String, dynamic>? assignedDietPlan;
//   int totalWeeksOpted; // New field to track total weeks opted for
//   List<int> assignedWeeks; // New field to track already assigned weeks
//
//   User({
//     required this.name,
//     required this.userId,
//     required this.email,
//     required this.gender,
//     required this.phone,
//     this.status = 'Active',
//     this.subscriptionType = 'Free',
//     this.dietPlanAccess = true,
//     this.loginEnabled = true,
//     this.assignedDietPlan,
//     this.totalWeeksOpted = 0, // Default to 0 weeks
//     this.assignedWeeks = const [], // Default to no weeks assigned
//   });
//
//   factory User.fromFirestore(Map<String, dynamic> data, String userId) {
//     return User(
//       name: data['name'] ?? '',
//       userId: userId,
//       email: data['email'] ?? '',
//       phone: data['phone'] ?? 'N/A',
//       gender: data['gender'] ?? 'Customer',
//       status: data['status'] ?? 'Active',
//       subscriptionType: data['subscriptionType'] ?? 'Free',
//       dietPlanAccess: data['dietPlanAccess'] ?? true,
//       loginEnabled: data['loginEnabled'] ?? true,
//       assignedDietPlan: data['assignedDietPlan'],
//       totalWeeksOpted: data['totalWeeksOpted'] ?? 0,
//       assignedWeeks: List<int>.from(data['assignedWeeks'] ?? []),
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'gender': gender,
//       'status': status,
//       'subscriptionType': subscriptionType,
//       'dietPlanAccess': dietPlanAccess,
//       'loginEnabled': loginEnabled,
//       'assignedDietPlan': assignedDietPlan,
//       'totalWeeksOpted': totalWeeksOpted,
//       'assignedWeeks': assignedWeeks,
//     };
//   }
// }
class User {
  final String name;
  final String userId;
  final String email;
  final String gender;
  final String phone;
  String status;
  String subscriptionType;
  bool dietPlanAccess;
  bool loginEnabled;
  Map<String, dynamic>? assignedDietPlan;
  int totalWeeksOpted; // New field for total weeks opted
  List<int> assignedWeeks; // New field for already assigned weeks

  User({
    required this.name,
    required this.userId,
    required this.email,
    required this.gender,
    required this.phone,
    this.status = 'Active',
    this.subscriptionType = 'Free',
    this.dietPlanAccess = true,
    this.loginEnabled = true,
    this.assignedDietPlan,
    this.totalWeeksOpted = 0, // Default 0 weeks
    this.assignedWeeks = const [], // Default empty list
  });

  factory User.fromFirestore(Map<String, dynamic> data, String userId) {
    return User(
      name: data['name'] ?? '',
      userId: userId,
      email: data['email'] ?? '',
      phone: data['phone'] ?? 'N/A',
      gender: data['gender'] ?? 'Customer',
      status: data['status'] ?? 'Active',
      subscriptionType: data['subscriptionType'] ?? 'Free',
      dietPlanAccess: data['dietPlanAccess'] ?? true,
      loginEnabled: data['loginEnabled'] ?? true,
      assignedDietPlan: data['assignedDietPlan'],
      totalWeeksOpted: data['totalWeeksOpted'] ?? 0,
      assignedWeeks: List<int>.from(data['assignedWeeks'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'status': status,
      'subscriptionType': subscriptionType,
      'dietPlanAccess': dietPlanAccess,
      'loginEnabled': loginEnabled,
      'assignedDietPlan': assignedDietPlan,
      'totalWeeksOpted': totalWeeksOpted,
      'assignedWeeks': assignedWeeks,
    };
  }
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  final UserController userController = Get.put(UserController());

  void filterUsers(String query) {
    setState(() {
      filteredUsers = userController.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.userId.contains(query) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.phone.contains(query) ||
            user.gender.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // void showDietPlanDetails(User user) {
  //   if (user.assignedDietPlan == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('No diet plan assigned to this user.')),
  //     );
  //     return;
  //   }
  //
  //   final dietPlan = user.assignedDietPlan!;
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Diet Plan Details',
  //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 8),
  //               Divider(),
  //               ListTile(
  //                 leading: Icon(Icons.restaurant_menu, color: Colors.green),
  //                 title: Text('Diet Plan Name'),
  //                 subtitle: Text(dietPlan['dietPlanDetails']['additionalPlanDetails']['dietPlanName'] ?? 'N/A'),
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.calendar_today, color: Colors.blue),
  //                 title: Text('Start Date'),
  //                 subtitle: Text(dietPlan['startDate'] ?? 'N/A'),
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.calendar_today, color: Colors.red),
  //                 title: Text('End Date'),
  //                 subtitle: Text(dietPlan['endDate'] ?? 'N/A'),
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.timer, color: Colors.orange),
  //                 title: Text('Assigned Date'),
  //                 subtitle: Text(dietPlan['assignedDate'] ?? 'N/A'),
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.weekend, color: Colors.purple),
  //                 title: Text('Week'),
  //                 subtitle: Text(dietPlan['week'].toString()),
  //               ),
  //               Divider(),
  //               Text(
  //                 'Meal Times',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Breakfast: ${dietPlan['dietPlanDetails']['mealTimes']['breakfast'] ?? 'N/A'}'),
  //                     Text('Lunch: ${dietPlan['dietPlanDetails']['mealTimes']['lunch'] ?? 'N/A'}'),
  //                     Text('Dinner: ${dietPlan['dietPlanDetails']['mealTimes']['dinner'] ?? 'N/A'}'),
  //                   ],
  //                 ),
  //               ),
  //               Divider(),
  //               Text(
  //                 'Food Categories',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               ...renderFoodCategories(dietPlan['dietPlanDetails']['foodCategories']),
  //               Divider(),
  //               Text(
  //                 'Additional Plan Details',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               ListTile(
  //                 title: Text('Type'),
  //                 subtitle: Text(dietPlan['dietPlanDetails']['additionalPlanDetails']['type'] ?? 'N/A'),
  //               ),
  //               ListTile(
  //                 title: Text('Cost'),
  //                 subtitle: Text(dietPlan['dietPlanDetails']['additionalPlanDetails']['cost'] ?? 'Free'),
  //               ),
  //               ListTile(
  //                 title: Text('Duration'),
  //                 subtitle: Text(dietPlan['dietPlanDetails']['additionalPlanDetails']['weeksDuration'] ??
  //                     dietPlan['dietPlanDetails']['additionalPlanDetails']['monthsDuration'] ??
  //                     'N/A'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void showDietPlanDetails(User user) {
    if (user.totalWeeksOpted == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This user has not opted for any weeks.')),
      );
      return;
    }

    final pendingWeeks = user.totalWeeksOpted - user.assignedWeeks.length;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diet Plan Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Divider(),
                if (user.assignedWeeks.isNotEmpty)
                  Text(
                    'Assigned Weeks: ${user.assignedWeeks.join(', ')}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                if (pendingWeeks > 0)
                  Text(
                    '$pendingWeeks week(s) diet plan pending to assign',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                Divider(),
                Text(
                  'Meal Times for Assigned Weeks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...user.assignedWeeks.map((week) {
                  return ListTile(
                    leading: Icon(Icons.weekend, color: Colors.purple),
                    title: Text('Week $week'),
                    subtitle: Text(
                      user.assignedDietPlan?['dietPlanDetails']['mealTimes']['week_$week'] ??
                          'N/A',
                    ),
                  );
                }),
                Divider(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    assignNewWeek(user);
                  },
                  child: Text('Assign Diet Plan for Pending Weeks'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void assignNewWeek(User user) async {
    if (user.totalWeeksOpted == user.assignedWeeks.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All weeks have already been assigned.')),
      );
      return;
    }

    final nextWeek = user.assignedWeeks.isNotEmpty
        ? user.assignedWeeks.last + 1
        : 1; // Get the next week to assign

    // Simulating assignment logic
    user.assignedWeeks.add(nextWeek);
    user.assignedDietPlan ??= {
      'dietPlanDetails': {
        'mealTimes': {
          'week_$nextWeek': 'Meal Plan for Week $nextWeek',
        },
      },
    };

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Assigned Diet Plan for Week $nextWeek')),
    );
  }

  List<Widget> renderFoodCategories(Map<String, dynamic>? foodCategories) {
    if (foodCategories == null) {
      return [Text('No food categories available.')];
    }
    return foodCategories.entries.map((entry) {
      final categoryName = entry.key;
      final items = entry.value as List<dynamic>;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "${item['name']} - ${item['calories']} cal (${item['vegetarian']})",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            );
          }).toList(),
        ],
      );
    }).toList();
  }
  static const Color primary = Color(0xff91b526);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Information',style: TextStyle(color: Colors.white),),
        backgroundColor: primary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: userController.fetchUsers,
          ),
        ],
      ),
      body: Obx(() {
        final users = filteredUsers.isEmpty ? userController.users : filteredUsers;
        if (userController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (users.isEmpty) {
          return Center(child: Text('No users found.'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: filterUsers,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, phone, or gender',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user.email}', style: TextStyle(fontSize: 14)),
                          Text('Phone: ${user.phone}', style: TextStyle(fontSize: 14)),
                          if (user.assignedDietPlan != null)
                            Text(
                              'Diet Plan: ${user.assignedDietPlan!['dietPlanDetails']['additionalPlanDetails']['dietPlanName'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 14, color:primary),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.green),
                        onPressed: () => showDietPlanDetails(user),
                      ),
                      onTap: () => showDietPlanDetails(user),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
