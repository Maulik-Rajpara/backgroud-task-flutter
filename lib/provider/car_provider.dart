import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/firebase_service.dart';

final carProvider = StateNotifierProvider<CarNotifier, AsyncValue<Map<String, dynamic>>>(
      (ref) => CarNotifier(),
);

class CarNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  CarNotifier() : super(const AsyncLoading()) {
    _fetchCarData();
  }

  final FirebaseService _firebaseService = FirebaseService();

  void _fetchCarData() {
    _firebaseService.getLastInsertedCarStream().listen((car) async {
      final totalRecords = await _firebaseService.getTotalRecordsCount();
      state = AsyncData({'lastCar': car, 'totalRecords': totalRecords});
    }, onError: (e) {
      state = AsyncError(e, StackTrace.current);
    });
  }
}