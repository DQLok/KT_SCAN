import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kt_scan_text/views/home/home.dart';
import 'package:kt_scan_text/views/result_filter/widgets/result_scan.dart';
import 'package:kt_scan_text/views/scans/scan_text_gg.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      
      home: HomePage(),
    );
  }
}