import 'package:flutter/material.dart';
import 'package:get/get.dart';

class User {
  final String name;
  final String userId;
  final String email;
  final String gender;
  String status; // Add status field to represent user status (blocked or active)

  User({
    required this.name,
    required this.userId,
    required this.email,
    required this.gender,
    this.status = 'Active', // Default status to 'Active'
  });
}

class UserController extends GetxController {
  // List of dummy users
  var users = <User>[
    User(name: 'John Doe', userId: '101', email: 'john@example.com', gender: 'Customer'),
    User(name: 'Jane Smith', userId: '102', email: 'jane@example.com', gender: 'Dietition'),
    User(name: 'Alice Johnson', userId: '103', email: 'alice@example.com', gender: 'Customer'),
    User(name: 'Bob Brown', userId: '104', email: 'bob@example.com', gender: 'Customer'),
    User(name: 'Eve Adams', userId: '105', email: 'eve@example.com', gender: 'Dietition'),
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

  void showAddUserDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController userIdController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController genderController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                TextField(controller: userIdController, decoration: InputDecoration(labelText: 'User ID')),
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                TextField(controller: genderController, decoration: InputDecoration(labelText: 'Gender')),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            userIdController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            genderController.text.isNotEmpty) {
                          final newUser = User(
                            name: nameController.text,
                            userId: userIdController.text,
                            email: emailController.text,
                            gender: genderController.text,
                          );
                          userController.addUser(newUser);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  // userController.approveUser(user.userId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.thumb_down, color: Colors.orange),
                title: Text('Disapprove'),
                onTap: () {
                  // Disapprove the user
                  // userController.disapproveUser(user.userId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text('Block User'),
                onTap: () {
                  // Block the user
                  userController.blockUser(user.userId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete User'),
                onTap: () {
                  // Remove the user
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Users Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: showAddUserDialog,
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add User'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
