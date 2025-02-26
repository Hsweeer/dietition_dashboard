import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data'; // For handling binary data

import '../utils/app-colors.dart';
import 'Diet plan form.dart';

class FoodItemsMasterController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var foodCategories = <String, RxList<Map<String, dynamic>>>{
    'Morning Tea': <Map<String, dynamic>>[].obs,
    'Breakfast': <Map<String, dynamic>>[].obs,
    'Mid Day Snacks': <Map<String, dynamic>>[].obs,
    'Lunch': <Map<String, dynamic>>[].obs,
    'Evening Snacks': <Map<String, dynamic>>[].obs,
    'Dinner': <Map<String, dynamic>>[].obs,
    'Bedtime Snack': <Map<String, dynamic>>[].obs,
  };

  var previousEntries = <String, RxList<Map<String, dynamic>>>{
    'Morning Tea': <Map<String, dynamic>>[].obs,
    'Breakfast': <Map<String, dynamic>>[].obs,
    'Mid Day Snacks': <Map<String, dynamic>>[].obs,
    'Lunch': <Map<String, dynamic>>[].obs,
    'Evening Snacks': <Map<String, dynamic>>[].obs,
    'Dinner': <Map<String, dynamic>>[].obs,
    'Bedtime Snack': <Map<String, dynamic>>[].obs,
  };

  @override
  void onInit() {
    super.onInit();
    fetchPreviousEntries();
  }

  Future<void> fetchPreviousEntries() async {
    for (String category in foodCategories.keys) {
      final snapshot = await _firestore.collection('foodItems').doc(category).get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(snapshot.data()?['items'] ?? []);
        previousEntries[category]?.assignAll(items);
      }
    }
  }

  Future<void> saveToFirebase(String category, Map<String, dynamic> item) async {
    previousEntries[category]?.add(item);
    await _firestore.collection('foodItems').doc(category).set({
      'items': previousEntries[category],
    });
  }

  void addFoodItem(String category) {
    foodCategories[category]?.add({
      'name': '',
      'vegetarian': 'Vegetarian',
      'calories': '',
      'images': [],
    });
  }

  void removeFoodItem(String category, int index) {
    if (foodCategories[category]!.length > index) {
      foodCategories[category]?.removeAt(index);
    }
  }

  void updateFoodItem(String category, int index, String field, dynamic value) {
    if (foodCategories[category]!.length > index) {
      foodCategories[category]?[index][field] = value;
      foodCategories[category]?.refresh();
    }
  }

  void reusePreviousItem(String category, Map<String, dynamic> item) {
    foodCategories[category]?.add(Map<String, dynamic>.from(item));
  }
}

class FoodItemsMasterScreen extends StatelessWidget {
  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;
  final int dietPlanDays;

  FoodItemsMasterScreen({
    Key? key,
    required this.breakfastTime,
    required this.lunchTime,
    required this.dinnerTime,
    required this.dietPlanDays,
  }) : super(key: key);

  final FoodItemsMasterController controller = Get.put(FoodItemsMasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Food Items Master'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diet Plan Duration: $dietPlanDays days',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => DietPlanScreen(
                    breakfastTime: breakfastTime,
                    lunchTime: lunchTime,
                    dinnerTime: dinnerTime,
                    dietPlanDays: dietPlanDays,
                    foodCategories: controller.foodCategories.map((key, value) {
                      return MapEntry(key, value.toList());
                    }),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                ),
                child: Text(
                  'Save Food Items and Go to Next Page',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCategoryWidget extends StatelessWidget {
  final String category;
  final RxList<Map<String, dynamic>> items;
  final RxList<Map<String, dynamic>> previousItems;
  final VoidCallback onAddItem;
  final Function(int index) onRemoveItem;
  final Function(int index, String field, dynamic value) onUpdateItem;
  final Function(Map<String, dynamic> item) onReuseItem;
  final Function(Map<String, dynamic> item) onSaveNewItem;

  const FoodCategoryWidget({
    Key? key,
    required this.category,
    required this.items,
    required this.previousItems,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onUpdateItem,
    required this.onReuseItem,
    required this.onSaveNewItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Obx(() => Column(
              children: [
                for (int index = 0; index < items.length; index++)
                  FoodItemWidget(
                    item: items[index],
                    onRemove: () => onRemoveItem(index),
                    onUpdateField: (field, value) => onUpdateItem(index, field, value),
                    onSave: () => onSaveNewItem(items[index]),
                  ),
              ],
            )),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onAddItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Add New Item',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Previous Items',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Divider(),
            Obx(() => previousItems.isEmpty
                ? Text('No previous items.')
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: previousItems.length,
              itemBuilder: (context, index) {
                final item = previousItems[index];
                return ListTile(
                  title: Text(item['name']),
                  trailing: Icon(Icons.copy, color: AppColors.primary),
                  onTap: () => onReuseItem(item),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class FoodItemWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(String field, dynamic value) onUpdateField;
  final VoidCallback onSave;

  const FoodItemWidget({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onUpdateField,
    required this.onSave,
  }) : super(key: key);

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  Uint8List? selectedImageBytes;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.item['name'];
    caloriesController.text = widget.item['calories'];
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedImageBytes = result.files.single.bytes;
      });

      widget.onUpdateField('images', [result.files.single.name]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
              onChanged: (value) => widget.onUpdateField('name', value),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: widget.item['vegetarian'],
              decoration: InputDecoration(labelText: 'Type'),
              items: ['Vegetarian', 'Non-Vegetarian']
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) => widget.onUpdateField('vegetarian', value),
            ),
            SizedBox(height: 10),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
              onChanged: (value) => widget.onUpdateField('calories', value),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text('Upload Picture'),
                ),
                if (selectedImageBytes != null)
                  Image.memory(
                    selectedImageBytes!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onSave();
                    Get.snackbar('Success', 'Item added successfully!',
                        backgroundColor: Colors.green, colorText: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text('Save'),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
