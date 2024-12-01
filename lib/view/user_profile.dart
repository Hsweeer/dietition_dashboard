import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Images_const/images_const.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: AssetImage(person,)),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin@gmail.com', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
