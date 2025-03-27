import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/foreground_service_manager.dart';
import '../entities/model/car_model.dart';
import '../service/firebase_service.dart';

class ForegroundServiceScreen extends ConsumerStatefulWidget {
  const ForegroundServiceScreen({super.key});

  @override
  ConsumerState<ForegroundServiceScreen> createState() => _ForegroundServiceScreenState();
}

class _ForegroundServiceScreenState extends ConsumerState<ForegroundServiceScreen> {
  bool isServiceRunning = false;
  bool isLoading = false;
  String? errorMessage;
  CarModel? lastInsertedCar;
  int totalRecords = 0;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _fetchLatestData();
  }

  Future<void> _fetchLatestData() async {
    try {
      final lastCar = await _firebaseService.fetchLastCar();
      final totalCount = await _firebaseService.getTotalRecordsCount();
      setState(() {
        lastInsertedCar = lastCar;
        totalRecords = totalCount;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _toggleService() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (isServiceRunning) {
        await ForegroundServiceManager.stopService();
      } else {
        await ForegroundServiceManager.startService();
      }
      setState(() {
        isServiceRunning = !isServiceRunning;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foreground Service")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else if (errorMessage != null)
              Text('Error: $errorMessage', style: const TextStyle(color: Colors.red))
            else
              Column(
                children: [
                  Text('Service Status: ${isServiceRunning ? "Running" : "Stopped"}'),
                  const SizedBox(height: 20),
                  lastInsertedCar != null
                      ? Text('Last Car: ${lastInsertedCar!.model}, ${lastInsertedCar!.year}, ${lastInsertedCar!.vehicleTag}')
                      : const Text('No data available'),
                  const SizedBox(height: 10),
                  Text('Total Records: $totalRecords'),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleService,
              child: Text(isServiceRunning ? "Stop Service" : "Start Service"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchLatestData,
              child: const Text("Refresh Data"),
            ),
          ],
        ),
      ),
    );
  }
}
