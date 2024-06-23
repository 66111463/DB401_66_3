import 'package:flutter/material.dart';
import 'report.dart'; // อ้างถึงไฟล์ report.dart

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container( // ไม่สามารถ const หน้า container ได้
          constraints: const BoxConstraints.expand(), // หากมี ? หมายถึงค่าสามารถใส่เป็น null ได้
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/cloud.gif'), // อ้างถึงรูปภาพที่ลงทะเบียน Asset images ในไฟล์ pubspec.yaml
              fit: BoxFit.cover // ปรับภาพให้ขนาดพอดีกับหน้าจอ
            )
          ),
          child: const Report(),
        ),
      ),
      theme: ThemeData( // กำหนด Theme ของตัวอักษร
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            color: Colors.white
          ),
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.yellow,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData( // กำหนด Theme ของปุ่ม
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blueAccent.shade700),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
          )
        )
      )
    );
  }
}
