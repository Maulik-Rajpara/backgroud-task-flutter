import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  static void startWorkManager() {
    Workmanager().registerPeriodicTask(
      "car_upload_task",
      "backgroundTask",
      initialDelay: const Duration(seconds: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: const Duration(minutes: 15),
    ).then((_) => print("WorkManager Task Registered"))
        .catchError((e) => print("Error in WorkManager: $e"));
  }

  static void stopWorkManager() {
    Workmanager().cancelAll();
    print("WorkManager Tasks Cancelled");
  }
}