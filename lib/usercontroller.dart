import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../view/users_screen.dart'; // Import the User model

class UserController extends GetxController {
  var users = <User>[].obs;
  var isLoading = true.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();  // Ensure you call fetchUsers when the controller is initialized
  }

  // Fetch users from Firebase Firestore
  Future<void> fetchUsers() async {
    try {
      isLoading(true); // Set loading state to true
      print("Fetching users...");

      var userSnapshot = await firestore.collection('users').get();

      // Check if data is fetched successfully
      print("Fetched ${userSnapshot.docs.length} users");

      // Map Firestore data to User objects
      users.value = userSnapshot.docs.map((doc) {
        // Handle cases where the field might be missing or null
        return User(
          name: doc.data()['username'] ?? 'No Name', // Use a fallback if 'username' is missing
          userId: doc.id,
          email: doc.data()['email'] ?? 'No Email', // Fallback for email
          gender: doc.data()['gender'] ?? 'Unknown', // Fallback for gender
        );
      }).toList();

      // Log users fetched
      print("Users: $users");

    } catch (e) {
      print("Error fetching users: $e");  // Log error if fetching fails
      Get.snackbar('Error', 'Failed to fetch users: $e');
    } finally {
      isLoading(false); // Set loading state to false once fetching is done
    }
  }

  // Add a new user to Firebase Firestore and the users list
  Future<void> addUser(User newUser) async {
    try {
      // Add the new user to Firestore
      DocumentReference docRef = await firestore.collection('users').add({
        'username': newUser.name,
        'email': newUser.email,
        'gender': newUser.gender,
      });

      // If the user is added successfully, add to the local list
      users.add(User(
        name: newUser.name,
        userId: docRef.id,
        email: newUser.email,
        gender: newUser.gender,
      ));

      Get.snackbar('Success', 'User added successfully!');
    } catch (e) {
      print("Error adding user: $e");
      Get.snackbar('Error', 'Failed to add user: $e');
    }
  }

  // Block a user (set blocked status to true)
  Future<void> blockUser(String userId) async {
    try {
      // Update the user's status in Firestore to 'blocked'
      await firestore.collection('users').doc(userId).update({
        'blocked': true,
      });

      // Update the local list of users to reflect the blocked status
      var user = users.firstWhere((user) => user.userId == userId);
      user.status = 'Blocked'; // Now that `status` is defined, we can modify it
      users.refresh();

      Get.snackbar('Success', 'User blocked successfully!');
    } catch (e) {
      print("Error blocking user: $e");
      Get.snackbar('Error', 'Failed to block user: $e');
    }
  }

  // Remove a user from Firestore and the local list
  Future<void> removeUser(String userId) async {
    try {
      // Delete the user from Firestore
      await firestore.collection('users').doc(userId).delete();

      // Remove the user from the local list
      users.removeWhere((user) => user.userId == userId);

      Get.snackbar('Success', 'User removed successfully!');
    } catch (e) {
      print("Error removing user: $e");
      Get.snackbar('Error', 'Failed to remove user: $e');
    }
  }
}
