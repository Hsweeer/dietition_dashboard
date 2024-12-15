import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DietPlansScreen extends StatefulWidget {
  @override
  _DietPlansScreenState createState() => _DietPlansScreenState();
}

class _DietPlansScreenState extends State<DietPlansScreen> {
  static const Color primary = Color(0xff91b526);
  static const Color secondary = Colors.white;

  // State variables
  String? selectedDietPlanId;
  Map<String, dynamic>? selectedDietPlan;
  List<String> selectedUserIds = [];

  late Future<List<Map<String, dynamic>>> _dietPlans;
  late Future<List<Map<String, dynamic>>> _users;

  @override
  void initState() {
    super.initState();
    _dietPlans = fetchDietPlans();
    _users = fetchUsers();
  }

  // Fetch Master Diet Plans
  Future<List<Map<String, dynamic>>> fetchDietPlans() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('MasterDietPlans')
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      print('Error fetching diet plans: $e');
      return [];
    }
  }

  // Fetch Users
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

  // Assign the selected diet plan to selected users
  Future<void> assignDietPlanToUsers() async {
    if (selectedDietPlan == null || selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a diet plan and at least one user.')),
      );
      return;
    }

    try {
      for (var userId in selectedUserIds) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'assignedDietPlan': selectedDietPlan,
          'assignedDate': DateTime.now().toIso8601String(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diet Plan assigned successfully!')),
      );

      setState(() {
        selectedUserIds.clear();
      });
    } catch (e) {
      print('Error assigning diet plan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Build Complete Diet Plan Details
  Widget buildDietPlanDetails(Map<String, dynamic> dietPlan) {
    bool isSelected = selectedDietPlanId == dietPlan['id'];

    return GestureDetector(
      onLongPress: () {
        setState(() {
          selectedDietPlanId = dietPlan['id'];
          selectedDietPlan = dietPlan;
        });
      },
      child: Card(
        margin: EdgeInsets.all(12),
        color: isSelected ? primary.withOpacity(0.3) : secondary,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: Text(
            dietPlan['additionalPlanDetails']['dietPlanName'] ?? 'No Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? secondary : primary,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            'Type: ${dietPlan['additionalPlanDetails']['type']} | Cost: ${dietPlan['additionalPlanDetails']['cost']}',
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Meal Times:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Breakfast: ${dietPlan['mealTimes']['breakfast']}'),
                  Text('Lunch: ${dietPlan['mealTimes']['lunch']}'),
                  Text('Dinner: ${dietPlan['mealTimes']['dinner']}'),
                  SizedBox(height: 10),
                  Text('Food Categories:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  for (var category in dietPlan['foodCategories'].keys)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category,
                            style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        for (var food in dietPlan['foodCategories'][category])
                          Text('- ${food['name']} (${food['calories']} cal)'),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Build User Card
  Widget buildUserCard(Map<String, dynamic> user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primary,
          child: Icon(Icons.person, color: secondary),
        ),
        title: Text(user['name'] ?? 'No Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
        subtitle: Text('Email: ${user['email'] ?? 'No Email'}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plans & Users', style: TextStyle(color: secondary)),
        backgroundColor: primary,
        centerTitle: true,
      ),
      backgroundColor: secondary,
      body: Row(
        children: [
          // Left Column: Master Diet Plans
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Master Diet Plans',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _dietPlans,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: primary));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Diet Plans Found.'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildDietPlanDetails(snapshot.data![index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 2, color: primary),
          // Right Column: Users
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Users',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _users,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: primary));
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primary, padding: EdgeInsets.all(12)),
                  onPressed: assignDietPlanToUsers,
                  child: Text('Assign Diet Plan',
                      style: TextStyle(fontSize: 18, color: secondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
