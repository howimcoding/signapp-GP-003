import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:signapp/translator.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة كاميرات الجهاز
  cameras = await availableCameras();
  // ربط مع الفايربيز
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // بداية تشغيل التطبيق
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign Language app Translator',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 32, 135, 239)),
        useMaterial3: true,
      ),
      home: Translator(),
    );
  }
}
