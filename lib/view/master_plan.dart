import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DietPlansScreenmaster extends StatefulWidget {
  @override
  _DietPlansScreenmasterState createState() => _DietPlansScreenmasterState();
}

class _DietPlansScreenmasterState extends State<DietPlansScreenmaster> {
  static const Color primary = Color(0xff91b526);
  static const Color secondary = Colors.white;

  String? selectedDietPlanId;
  Map<String, dynamic>? selectedDietPlan;
  int? selectedWeek;
  Map<int, Map<String, dynamic>> assignedWeeks = {};
  List<String> selectedUserIds = [];
  DateTime? startDate;
  DateTime? endDate;

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

  List<Widget> renderWeeks() {
    final totalWeeks = calculateWeeks();
    if (totalWeeks == 0) return [];

    return List.generate(totalWeeks, (index) {
      final weekNum = index + 1;
      final isAssigned = assignedWeeks.containsKey(weekNum);

      return GestureDetector(
        onTap: () {
          setState(() {
            selectedWeek = weekNum;
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: selectedWeek == weekNum ? primary.withOpacity(0.2) : secondary,
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
                    color: selectedWeek == weekNum ? primary : primary,
                  ),
                ),
                Icon(
                  isAssigned ? Icons.check_circle : Icons.circle_outlined,
                  color: isAssigned ? primary : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> assignDietPlanToUsers() async {
    if (selectedDietPlan == null ||
        selectedUserIds.isEmpty ||
        selectedWeek == null ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all required fields.')),
      );
      return;
    }

    try {
      for (var userId in selectedUserIds) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'assignedDietPlan': assignedWeeks[selectedWeek],
          'assignedDate': DateTime.now().toIso8601String(),
          'week': selectedWeek,
          'startDate': startDate?.toIso8601String(),
          'endDate': endDate?.toIso8601String(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diet Plan assigned successfully!')),
      );

      setState(() {
        selectedUserIds.clear();
        startDate = null;
        endDate = null;
      });
    } catch (e) {
      print('Error assigning diet plan to users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> pickStartDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        startDate = selected;
      });
    }
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
        title: Text('Diet Plans & Users', style: TextStyle(color: secondary)),
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
                    'Weeks',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                  ),
                ),
                Expanded(
                  child: ListView(children: renderWeeks()),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                    ),
                    onPressed: () => pickStartDate(context),
                    child: Text(
                      'Select Start Date',
                      style: TextStyle(fontSize: 18, color: secondary),
                    ),
                  ),
                ),
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
                          fontSize: 16, color: primary, fontWeight: FontWeight.bold),
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
                    'Assign Diet Plan to Users',
                    style: TextStyle(fontSize: 18, color: secondary),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserCard(Map<String, dynamic> user) {
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
}
