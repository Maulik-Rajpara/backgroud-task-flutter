import 'dart:math';

import 'package:ablecred/entities/model/car_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '../../service/firebase_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background task started");

    // Ensure Firebase is initialized
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final FirebaseService firebaseService = FirebaseService();
    // Dummy car object
    CarModel car = CarModel(
      model: "Tesla-${Random().nextInt(1000)}",
      year: 2025,
      vehicleTag: "XY${Random().nextInt(1000)}",
      timestamp: DateTime.now().toIso8601String(),
    );

    await firebaseService.insertCar(car);
    return Future.value(true);
  });
}
