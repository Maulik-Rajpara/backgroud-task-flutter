import 'dart:math';

import 'package:ablecred/entities/model/car_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:workmanager/workmanager.dart';


class FirebaseService {
   static final DatabaseReference _db = FirebaseDatabase.instance.ref().child("cars");

   Future<void> insertCar(CarModel car) async {
    try {

      await _db.push().set(car.toMap()).then((onValue){
        print("Car ss :");
      },onError: (e){
        print("Car e $e");
      });

    } catch (e) {
      print("Error inserting car: $e");
    }
  }

   Future<CarModel?> fetchLastCar() async {
     try {
       DatabaseEvent event = await _db.orderByKey().limitToLast(1).once();

       if (event.snapshot.value == null) {
         return null;  // No records exist
       }

       var lastCar = (event.snapshot.value as Map).values.first;
       return CarModel.fromJson(Map<String, dynamic>.from(lastCar));
     } catch (e,s) {
       print("Error fetching last car: $e $s");
       return null;
     }
   }

  Future<int> getTotalRecordsCount() async {
     try {
       DatabaseEvent event = await _db.once();
       if (event.snapshot.exists) {
         Map<dynamic, dynamic> records = event.snapshot.value as Map<dynamic, dynamic>;
         return records.length;  // Returns total count of records
       }
     } catch (e) {
       print("Error fetching total records count: $e");
     }
     return 0; // Return 0 if there is an error or no records
   }

  Stream<CarModel?> getLastInsertedCarStream() {
     return _db.orderByKey().limitToLast(1).onValue.map((event) {
       if (event.snapshot.value != null) {
         final rawData = event.snapshot.value as Map<Object?, Object?>;

         // Convert Map<Object?, Object?> to Map<String, dynamic>
         final data = rawData.map((key, value) =>
             MapEntry(key.toString(), value as Map<Object?, Object?>));

         // Print debug log
         print("getLastInsertedCarStream: $data");

         // Extract the first entry and convert it properly
         final lastEntry = data.entries.first.value.map((key, value) =>
             MapEntry(key.toString(), value));

         return CarModel.fromJson(lastEntry);
       }
       return null;
     });
  }

}
