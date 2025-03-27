import 'package:ablecred/ui/isolation_screen.dart';
import 'package:ablecred/ui/work_manager_screen.dart';
import 'package:ablecred/ui/foreground_service_screen.dart';
import 'package:ablecred/utils/callback/callback_dispatcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((v){
    print("VV");
  },onError: (e){
    print("onError $e");
  });
  Workmanager().initialize(callbackDispatcher,
      isInDebugMode: true,);
  runApp(const ProviderScope(child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Background Tasks',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  HomeScreen(),
    );
  }
}



class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Background Task Options')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(

              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    WorkManagerScreen()),
              ),
              child: Text('WorkManager Approach'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForegroundServiceScreen()),
              ),
              child: Text('Foreground Service'),
            ),
            SizedBox(height: 10,),

            ElevatedButton(  onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  IsolateScreen()),
            ),child: Text('Isolate Task')),
          ],
        ),
      ),
    );
  }
}
