import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../entities/model/car_model.dart';
import '../services/isolate_manager.dart';

class IsolateScreen extends ConsumerStatefulWidget {
  const IsolateScreen({super.key});

  @override
  ConsumerState<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends ConsumerState<IsolateScreen> {
  CarModel? lastInsertedCar;
  int totalRecords = 0;
  bool isLoading = false;
  String? errorMessage;

  Future<void> startIsolate() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    await IsolateManager.startTask((result) {
      if (result['status'] == 'success') {
        setState(() {
          lastInsertedCar = result['lastCar'] != null
              ? CarModel.fromJson(result['lastCar'])
              : null;
          totalRecords = result['totalCount'] as int;
          isLoading = false;
        });
      } else if (result['status'] == 'error') {
        setState(() {
          errorMessage = result['error'] as String;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isolate Execution")),
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
                  lastInsertedCar != null
                      ? Text('Last Car: ${lastInsertedCar!.model}, ${lastInsertedCar!.year}, ${lastInsertedCar!.vehicleTag}')
                      : const Text('No data available'),
                  const SizedBox(height: 10),
                  Text('Total Records: $totalRecords'),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startIsolate,
              child: const Text("Run Isolate Task"),
            ),
          ],
        ),
      ),
    );
  }
}
