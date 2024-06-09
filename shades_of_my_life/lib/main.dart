import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // ถ้าใน Code เป็นแบบนิ่งๆ จะแนะนำให้เติม const (Constructor) ไว้ด้านหน้า
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
} //'_' Underscore means this state is private (internal) only.

class _MyAppState extends State<MyApp> {
  int shade = 16777215; // Shade ต้องสร้างไว้นอก Method และต้องอยู่ใน Class เพื่อให้ใครก็ได้มาหยิบใช้

  @override
  Widget build(BuildContext context) {
    void changeColor(y) { // การเติม void คือการบอกว่าจะไม่มีการ return อะไรกลับมา แต่โดยปกติจะต้องใส่ให้มีการ return ผลลัพธ์อะไรกลับมาสักอย่างเช่น int
      double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      shade = (y / height * 16777215).round(); // .dy เท่ากับ dimension = แกน y
      // shade = (details.localPosition.dy / height * 16777215).round(); // .dy เท่ากับ dimension = แกน y
      // shade -= 100; // ได้ค่าเดียวกันกับ shade = shade -100
      if (shade < 0) {
        shade = 0;
      } else if (shade > 16777215) {
        shade = 16777215;
      }
    }
    
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTapDown: (details) {
              setState(() => changeColor(details.localPosition.dy)); // คำสั่งบรรทัดเดียวแนะนำให้ใช้ Arrow function และตัด ; ออกไปได้
            },
            onVerticalDragUpdate: (details) {
              setState(() => changeColor(details.localPosition.dy));
              // on คือ Event เป็นฟังก์ชั่นตัวหนึ่ง
              // ปีกกา {} เป็น Anonymous function
              // => คำสั่งเดียวจะให้ใช้เป็น Arrow function
            }
          )
          // GestureDetector เป็น Widget ที่เอาไว้ใช้ตรวจสอบการสัมพัสกับหน้าจอ
        ),
        backgroundColor: Color(0xFF000000 + shade)
      )
    );
  }
}