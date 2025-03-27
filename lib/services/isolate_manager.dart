import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import '../entities/model/car_model.dart';
import '../service/firebase_service.dart';


class IsolateManager {
  static Future<void> _backgroundTask(SendPort sendPort) async {
    try {

      // Simulate heavy computation (inside the isolate)
      CarModel newCar = CarModel(
        model: "Toyota-${Random().nextInt(1000)}",
        year: 2024,
        vehicleTag: "XY${Random().nextInt(1000)}",
        timestamp: DateTime.now().toIso8601String(),
      );

      // Send generated car object back to main isolate
      sendPort.send(newCar.toMap());
    } catch (e) {
      sendPort.send({"status": "error", "error": e.toString()});
    }
  }

  static Future<void> startTask(Function(Map<String, dynamic>) callback) async {
    ReceivePort receivePort = ReceivePort();

    // Listen to the isolate message
    receivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        FirebaseService firebaseService = FirebaseService();

        // Insert car into Firebase (executed in the main isolate)
        CarModel newCar = CarModel.fromJson(message);
        await firebaseService.insertCar(newCar);

        // Fetch the last inserted car and total records
        CarModel? lastCar = await firebaseService.fetchLastCar();
        int totalRecords = await firebaseService.getTotalRecordsCount();

        // Send data back to UI
        callback({
          "status": "success",
          "lastCar": lastCar?.toMap(),
          "totalCount": totalRecords,
        });
      } else {
        callback({"status": "error", "error": "Invalid data received"});
      }
    });


    await Isolate.spawn(_backgroundTask, receivePort.sendPort);
  }
}
