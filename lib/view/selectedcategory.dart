import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class FoodSelectionScreen extends StatefulWidget {
  final List<Map<String, dynamic>> foodItemsByCategory;
  final Set<String> selectedFoodItemIds;

  const FoodSelectionScreen({
    Key? key,
    required this.foodItemsByCategory,
    required this.selectedFoodItemIds,
  }) : super(key: key);

  @override
  _FoodSelectionScreenState createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  late Set<String> selectedFoodItemIds;

  @override
  void initState() {
    super.initState();
    selectedFoodItemIds = Set.from(widget.selectedFoodItemIds);
  }

  void toggleSelection(String uniqueKey) {
    setState(() {
      if (selectedFoodItemIds.contains(uniqueKey)) {
        selectedFoodItemIds.remove(uniqueKey);
      } else {
        selectedFoodItemIds.add(uniqueKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Food Items'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedFoodItemIds);
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        children: widget.foodItemsByCategory.map<Widget>((category) {
          return ExpansionTile(
            title: Text(category['category'] ?? 'Unknown Category'),
            children: (category['items'] as List<dynamic>).map<Widget>((item) {
              final uniqueKey = '${category['category']}-${item['name']}';

              return CheckboxListTile(
                title: Text(item['name'] ?? 'Unknown Item'),
                subtitle: Text(
                    'Calories: ${item['calories']}, Vegetarian: ${item['vegetarian']}'),
                value: selectedFoodItemIds.contains(uniqueKey),
                onChanged: (isChecked) {
                  toggleSelection(uniqueKey);
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

