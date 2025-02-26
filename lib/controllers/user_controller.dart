import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../view/users_screen.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var users = <User>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      users.value = snapshot.docs
          .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(User user) async {
    try {
      await _firestore.collection('users').add(user.toFirestore());
      fetchUsers();
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.userId).update(user.toFirestore());
      fetchUsers();
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      fetchUsers();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> toggleDietPlanAccess(String userId) async {
    final user = users.firstWhere((u) => u.userId == userId);
    user.dietPlanAccess = !user.dietPlanAccess;
    await updateUser(user);
  }

  Future<void> toggleLogin(String userId) async {
    final user = users.firstWhere((u) => u.userId == userId);
    user.loginEnabled = !user.loginEnabled;
    await updateUser(user);
  }

  Future<void> blockUser(String userId) async {
    final user = users.firstWhere((u) => u.userId == userId);
    user.status = 'Blocked';
    await updateUser(user);
  }
}
