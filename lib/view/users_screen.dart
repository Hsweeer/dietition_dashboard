import 'package:flutter/material.dart';
import 'package:get/get.dart';

class User {
  final String name;
  final String userId;
  final String email;
  final String gender;
  String status; // Add status field to represent user status (blocked or active)
  String subscriptionType; // 'Paid' or 'Free'
  bool dietPlanAccess; // Access to diet plan
  bool loginEnabled; // If the login is enabled

  User({
    required this.name,
    required this.userId,
    required this.email,
    required this.gender,
    this.status = 'Active', // Default status to 'Active'
    this.subscriptionType = 'Free', // Default subscription to 'Free'
    this.dietPlanAccess = true, // Default access to diet plans
    this.loginEnabled = true, // Default login is enabled
  });
}

class UserController extends GetxController {
  // List of dummy users
  var users = <User>[
    User(name: 'John Doe', userId: '101', email: 'john@example.com', gender: 'Customer'),
    User(name: 'Jane Smith', userId: '102', email: 'jane@example.com', gender: 'Dietitian', subscriptionType: 'Paid'),
    User(name: 'Alice Johnson', userId: '103', email: 'alice@example.com', gender: 'Customer'),
    User(name: 'Bob Brown', userId: '104', email: 'bob@example.com', gender: 'Customer', subscriptionType: 'Paid'),
    User(name: 'Eve Adams', userId: '105', email: 'eve@example.com', gender: 'Dietitian'),
  ].obs;

  var isLoading = false.obs;

  void addUser(User user) {
    users.add(user);
  }

  void blockUser(String userId) {
    final user = users.firstWhere((u) => u.userId == userId, orElse: () => User(name: '', userId: '', email: '', gender: ''));
    if (user.userId.isNotEmpty) {
      user.status = 'Blocked';
      update();
    }
  }

  void removeUser(String userId) {
    users.removeWhere((u) => u.userId == userId);
  }

  void toggleDietPlanAccess(String userId) {
    final user = users.firstWhere((u) => u.userId == userId, orElse: () => User(name: '', userId: '', email: '', gender: ''));
    if (user.userId.isNotEmpty) {
      user.dietPlanAccess = !user.dietPlanAccess;
      update();
    }
  }

  void toggleLogin(String userId) {
    final user = users.firstWhere((u) => u.userId == userId, orElse: () => User(name: '', userId: '', email: '', gender: ''));
    if (user.userId.isNotEmpty) {
      user.loginEnabled = !user.loginEnabled;
      update();
    }
  }

  List<User> getDietitianReports() {
    return users.where((user) => user.gender.toLowerCase() == 'dietitian').toList();
  }

  List<User> getPaidUsers() {
    return users.where((user) => user.subscriptionType.toLowerCase() == 'paid').toList();
  }

  List<User> getFreeUsers() {
    return users.where((user) => user.subscriptionType.toLowerCase() == 'free').toList();
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
            user.gender.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void showOptions(User user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.thumb_up, color: Colors.green),
                title: Text('Approve'),
                onTap: () {
                  // Approve the user
                  user.status = 'Active';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.thumb_down, color: Colors.orange),
                title: Text('Disapprove'),
                onTap: () {
                  // Disapprove the user
                  user.status = 'Disapproved';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text('Block User'),
                onTap: () {
                  userController.blockUser(user.userId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.no_meals, color: Colors.redAccent),
                title: Text(user.dietPlanAccess ? 'Disable Diet Plan Access' : 'Enable Diet Plan Access'),
                onTap: () {
                  userController.toggleDietPlanAccess(user.userId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_off, color: Colors.red),
                title: Text(user.loginEnabled ? 'Disable Login' : 'Enable Login'),
                onTap: () {
                  userController.toggleLogin(user.userId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete User'),
                onTap: () {
                  userController.removeUser(user.userId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showReports() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final dietitianReports = userController.getDietitianReports();
        final paidUsers = userController.getPaidUsers();
        final freeUsers = userController.getFreeUsers();
        return AlertDialog(
          title: Text('Reports'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dietitians Handling Clients:'),
                for (var dietitian in dietitianReports)
                  Text('${dietitian.name} (${dietitian.userId})'),
                SizedBox(height: 10),
                Text('Paid Users:'),
                for (var user in paidUsers) Text('${user.name} (${user.userId})'),
                SizedBox(height: 10),
                Text('Free Users:'),
                for (var user in freeUsers) Text('${user.name} (${user.userId})'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
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
      appBar: AppBar(
        title: Text('Users Information'),
        actions: [
          IconButton(
            icon: Icon(Icons.report),
            onPressed: showReports,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: filterUsers,
              decoration: InputDecoration(
                hintText: 'Search by name, user ID, email, or gender',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              final users = filteredUsers.isEmpty ? userController.users : filteredUsers;
              if (users.isEmpty) {
                return Center(child: Text('No users found.'));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(user.name)),
                          Expanded(child: Text(user.userId)),
                          Expanded(child: Text(user.email)),
                          Expanded(child: Text(user.gender)),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () => showOptions(user),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
