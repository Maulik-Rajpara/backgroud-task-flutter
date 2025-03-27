
import 'dart:math';

import 'package:ablecred/services/work_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import '../entities/model/car_model.dart';
import '../provider/car_provider.dart';
import '../service/firebase_service.dart';



class WorkManagerScreen extends ConsumerStatefulWidget {
  const WorkManagerScreen({super.key});

  @override
  ConsumerState<WorkManagerScreen> createState() => _WorkManagerScreenState();
}

class _WorkManagerScreenState extends ConsumerState<WorkManagerScreen> {
  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context,) {
    final carState = ref.watch(carProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("WorkManager Execution")),
      body: Center(
        child: carState.when(
          data: (data) {
            final car = data['lastCar'] as CarModel?;
            final totalRecords = data['totalRecords'] as int;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                car != null
                    ? Text('Last Car: ${car.model}, ${car.year}, ${car.vehicleTag}')
                    : const Text('No data available'),
                const SizedBox(height: 20),
                Text('Total Records: $totalRecords'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    WorkManagerService.startWorkManager();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Background task started")));
                  },
                  child: const Text("Start WorkManager"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    WorkManagerService.stopWorkManager();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Background task stopped")));
                  },
                  child: const Text("Stop WorkManager"),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}
