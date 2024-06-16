import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // import geocoding หลังติดตั้ง flutter pub add geocoding
import 'location.dart'; // อ้างถึงไฟล์ location.dart

// ชื่อ Class นิยิมขึ้นต้นด้วย Uppercase
// StatefulWidget
class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState(); // '_' เป็น Local class
}

class _ReportState extends State<Report> {
  @override
  void initState() { // เพิ่ม getCurrentLocation หลัง Import location มาแล้ว เนื่องจากเป็น Function ทำงานแค่ครั้งเดียวจบ ให้ใช้คำสั่ง initState ด้านหน้าด้วย
    getCurrentLocation().then(
      (location) => placemarkFromCoordinates(
        location.latitude,
        location.longitude
      ).then((placemarks) => print(placemarks.first))
      //(value) => print(value) // สร้างตัวแปร value แล้วสั่งให้ print ออกมาเป็น "print เป็นคำสั่ง debug จึงควรนำออกหากต้อง release เป็น production" 
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // จัดเรียงตามแนวตั้งตรงกลางจอ
      children: [
        const Text('สภาพอากาศวันนี้',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        Container( 
          constraints: const BoxConstraints.tightFor(
            width: 150,
            height: 150
          ), // กำหนดขนาดแบบ Fixed size
          decoration: BoxDecoration(
            color: Colors.blueAccent.shade700.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10) // ลบมุมขอบให้มนทั้งหมด 10 จุด
          ),
          margin: const EdgeInsets.symmetric(vertical: 30) // กำหนดระยะให้ไม่ชิด Widget กันเกินไป
        ),
        FilledButton(
          onPressed: () {},
          child: const Text('Refresh')
        ) // เพิ่มปุ่ม Refresh
      ], // ใส่สมาชิก Widget ได้หลายตัว
    ); // Column ใกล้เคียงกับเคียงกับ Container เรียงจากบนลงล่างตามแนวตั้ง
  }
}