// import 'dart:io'; // For File class
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // For picking images
//
// class ChangeImages extends StatefulWidget {
//   const ChangeImages({super.key});
//
//   @override
//   State<ChangeImages> createState() => _ChangeImagesState();
// }
//
// class _ChangeImagesState extends State<ChangeImages> {
//   final ImagePicker _picker = ImagePicker();
//
//   // A map to hold section names and their current image paths
//   Map<String, String?> imageSections = {
//     'Profile Image': null, // Initially no image selected
//     'Banner Image': null,
//     'Logo Image': null,
//   };
//
//   // Function to pick and update an image for a specific section
//   Future<void> _pickImage(String sectionName) async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         imageSections[sectionName] = pickedFile.path; // Update the image path
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Change Images'),
//       ),
//       body: ListView.builder(
//         itemCount: imageSections.length,
//         itemBuilder: (context, index) {
//           String sectionName = imageSections.keys.elementAt(index);
//           String? currentImagePath = imageSections[sectionName];
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   sectionName,
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () => _pickImage(sectionName), // Open image picker on tap
//                   child: Container(
//                     width: double.infinity,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.black26),
//                       color: Colors.grey[300],
//                     ),
//                     child: currentImagePath != null
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         File(currentImagePath), // Display the current image
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                         : const Center(
//                       child: Text(
//                         'Tap to select image',
//                         style: TextStyle(fontSize: 16, color: Colors.black54),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
