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
    );
  }
}
