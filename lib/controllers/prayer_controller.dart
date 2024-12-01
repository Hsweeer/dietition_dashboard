import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PrayerController extends GetxController {
  var prayerNames = <String>['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'].obs;
  var prayerTimes = <RxString>[
    ''.obs, ''.obs, ''.obs, ''.obs, ''.obs
  ];
  var prayerJamahTimes = <RxString>[
    ''.obs, ''.obs, ''.obs, ''.obs, ''.obs
  ];
  var prayerEndTimes = <RxString>[
    ''.obs, ''.obs, ''.obs, ''.obs, ''.obs
  ];

  Future<void> pickTime(BuildContext context, RxString controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context); // Formats time based on the locale
      controller.value = formattedTime;  // Update the RxString value directly
    }
  }
}
