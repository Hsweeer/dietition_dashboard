import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../utils/app-colors.dart';
import 'Diet plan form.dart';

// class FoodItemsMasterScreen extends StatefulWidget {
//   final TimeOfDay breakfastTime;
//   final TimeOfDay lunchTime;
//   final TimeOfDay dinnerTime;
//   final DateTime? dietPlanExpiryDate;
//   final DateTime? planExpiryDate;
//
//   const FoodItemsMasterScreen({
//     Key? key,
//     required this.breakfastTime,
//     required this.lunchTime,
//     required this.dinnerTime,
//     this.dietPlanExpiryDate,
//     this.planExpiryDate,
//   }) : super(key: key);
//
//   @override
//   _FoodItemsMasterScreenState createState() => _FoodItemsMasterScreenState();
// }
//
// class _FoodItemsMasterScreenState extends State<FoodItemsMasterScreen> {
//   final Map<String, List<Map<String, dynamic>>> foodCategories = {
//     'Morning Tea': [],
//     'Breakfast': [],
//     'Mid Day Snacks': [],
//     'Lunch': [],
//     'Evening Snacks': [],
//     'Dinner': [],
//     'Bedtime Snack': [],
//   };
//
//   void addFoodItem(String category) {
//     setState(() {
//       foodCategories[category]?.add({
//         'name': '',
//         'vegetarian': 'Vegetarian', // Default value
//         'calories': '',
//         'images': [],
//       });
//     });
//   }
//
//   void removeFoodItem(String category, int index) {
//     setState(() {
//       foodCategories[category]?.removeAt(index);
//     });
//   }
//
//   void updateFoodItem(
//       String category, int index, String field, dynamic value) {
//     setState(() {
//       foodCategories[category]?[index][field] = value;
//     });
//   }
//
//   void uploadImage(String category, int index, List<String> images) {
//     setState(() {
//       foodCategories[category]?[index]['images'] = images;
//     });
//   }
//
//   void saveDietPlan() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DietPlanScreen(
//           breakfastTime: widget.breakfastTime,
//           lunchTime: widget.lunchTime,
//           dinnerTime: widget.dinnerTime,
//           dietPlanExpiryDate: widget.dietPlanExpiryDate,
//           planExpiryDate: widget.planExpiryDate,
//           foodCategories: foodCategories,
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 45,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: AppColors.primary,
//               ),
//               child: Center(
//                 child: Text(
//                   'Food Items Master',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ...foodCategories.entries.map((entry) {
//                   return FoodCategoryWidget(
//                     category: entry.key,
//                     items: entry.value,
//                     onAddItem: () => addFoodItem(entry.key),
//                     onRemoveItem: (index) => removeFoodItem(entry.key, index),
//                     onUpdateItem: (index, field, value) =>
//                         updateFoodItem(entry.key, index, field, value),
//                     onUploadImages: (index, images) =>
//                         uploadImage(entry.key, index, images),
//                   );
//                 }).toList(),
//                 SizedBox(height: 20), // Space between the list and button
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: saveDietPlan,
//                     child: Text('Save Diet Plan',
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FoodItemsMasterScreen extends StatefulWidget {
  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;
  final int dietPlanDays; // Added parameter for diet plan days

  const FoodItemsMasterScreen({
    Key? key,
    required this.breakfastTime,
    required this.lunchTime,
    required this.dinnerTime,
    required this.dietPlanDays, // Mark as required
  }) : super(key: key);

  @override
  _FoodItemsMasterScreenState createState() => _FoodItemsMasterScreenState();
}

class _FoodItemsMasterScreenState extends State<FoodItemsMasterScreen> {
  final Map<String, List<Map<String, dynamic>>> foodCategories = {
    'Morning Tea': [],
    'Breakfast': [],
    'Mid Day Snacks': [],
    'Lunch': [],
    'Evening Snacks': [],
    'Dinner': [],
    'Bedtime Snack': [],
  };

  void addFoodItem(String category) {
    setState(() {
      foodCategories[category]?.add({
        'name': '',
        'vegetarian': 'Vegetarian', // Default value
        'calories': '',
        'images': [],
      });
    });
  }

  void removeFoodItem(String category, int index) {
    setState(() {
      foodCategories[category]?.removeAt(index);
    });
  }

  void updateFoodItem(
      String category, int index, String field, dynamic value) {
    setState(() {
      foodCategories[category]?[index][field] = value;
    });
  }

  void uploadImage(String category, int index, List<String> images) {
    setState(() {
      foodCategories[category]?[index]['images'] = images;
    });
  }

  void saveDietPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DietPlanScreen(
          breakfastTime: widget.breakfastTime,
          lunchTime: widget.lunchTime,
          dinnerTime: widget.dinnerTime,
          dietPlanDays: widget.dietPlanDays, // Pass to the next screen
          foodCategories: foodCategories,
        ),
      ),
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
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  'Food Items Master',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Diet Plan Duration: ${widget.dietPlanDays} days',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...foodCategories.entries.map((entry) {
                  return FoodCategoryWidget(
                    category: entry.key,
                    items: entry.value,
                    onAddItem: () => addFoodItem(entry.key),
                    onRemoveItem: (index) => removeFoodItem(entry.key, index),
                    onUpdateItem: (index, field, value) =>
                        updateFoodItem(entry.key, index, field, value),
                    onUploadImages: (index, images) =>
                        uploadImage(entry.key, index, images),
                  );
                }).toList(),
                SizedBox(height: 20), // Space between the list and button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: saveDietPlan,
                    child: Text('Save Diet Plan',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCategoryWidget extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final VoidCallback onAddItem;
  final Function(int index) onRemoveItem;
  final Function(int index, String field, dynamic value) onUpdateItem;
  final Function(int index, List<String> images) onUploadImages;

  const FoodCategoryWidget({
    Key? key,
    required this.category,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onUpdateItem,
    required this.onUploadImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
            Column(
              children: items.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;

                return FoodItemWidget(
                  item: item,
                  onRemove: () => onRemoveItem(index),
                  onUpdateField: (field, value) =>
                      onUpdateItem(index, field, value),
                  onUploadImages: (images) =>
                      onUploadImages(index, images),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: onAddItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add ${category} Item',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(String field, dynamic value) onUpdateField;
  final Function(List<String> images) onUploadImages;

  const FoodItemWidget({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onUpdateField,
    required this.onUploadImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Item Name'),
              onChanged: (value) => onUpdateField('name', value),
            ),
            DropdownButtonFormField<String>(
              value: item['vegetarian'],
              items: ['Vegetarian', 'Non-Vegetarian']
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) => onUpdateField('vegetarian', value),
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Calories (Optional)'),
              onChanged: (value) => onUpdateField('calories', value),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: List.generate(
                item['images']?.length ?? 0,
                    (index) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['images'][index],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              )..add(
                InkWell(
                  onTap: () => {}, // Handle image picking
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}