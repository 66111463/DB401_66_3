import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart'; // import geocoding หลังติดตั้ง flutter pub add geocoding
import 'forecast.dart'; // อ้างถึงไฟล์ forecast.dart
import 'location.dart'; // อ้างถึงไฟล์ location.dart
import 'weather.dart'; // อ้างถึงไฟล์ weather.dart

// ชื่อ Class นิยิมขึ้นต้นด้วย Uppercase
// StatefulWidget
class Report extends StatefulWidget {
  const Report({super.key});

  @override // สามารถ Override ค่าภายในได้
  State<Report> createState() => _ReportState(); // '_' เป็น Local class
}

class _ReportState extends State<Report> {
  Weather? _weather; // Weather? '?' เท่ากับจะมีค่าหรือไม่มีก็ได้
  bool _progress = false; // boolean เป็นค่า TRUE หรือ FLASE เท่านั้น

  void updateReport() { // สร้าง Method ที่ไม่ต้องการ return อะไรกลับมาให้มี void คั่นหน้า
    forecast() // chained futures
    .whenComplete(() { // สร้าง Function เมื่อ complete
      if (_progress) {
        _progress = false;
        Navigator.pop(context);
      }
    })
    .then((weather) {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner(); // ถ้าไม่เจอ error แล้วให้ remove SnackBar
      setState(() {
        _weather = weather;
      });
    })
    .catchError((error) { // สร้างตัวแปร future error หาก chain เจอ error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(days: 1),
        )
      );
    });
  }

  @override
  void initState() { // เพิ่ม getCurrentLocation หลัง Import location มาแล้ว เนื่องจากเป็น Function ทำงานแค่ครั้งเดียวจบ ให้ใช้คำสั่ง initState ด้านหน้าด้วย
  //  getCurrentLocation().then(
  //    (location) => placemarkFromCoordinates(
  //      location.latitude,
  //      location.longitude
  //    ).then((placemarks) => print(placemarks.first))
  //    //(value) => print(value) // สร้างตัวแปร value แล้วสั่งให้ print ออกมาเป็น "print เป็นคำสั่ง debug จึงควรนำออกหากต้อง release เป็น production" 
  //  );
    updateReport();
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
          constraints: 
            _weather == null ? 
            const BoxConstraints.tightFor( // กำหนดขนาดแบบ Fixed size
              width: 150, 
              height: 150
          ) : 
          null, 
          decoration: BoxDecoration(
            color: Colors.blueAccent.shade700.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10) // ลบมุมขอบให้มนทั้งหมด 10 จุด
          ),
          padding: const EdgeInsets.all(20), // กำหนดขอบ Padding ไม่ให้ชิดเกินไป
          margin: const EdgeInsets.symmetric(vertical: 30), // กำหนดระยะให้ไม่ชิด Widget กันเกินไป
          child: // ข้อมูลภายใน Conatainer หรือ child ควรอยู่ลำดับสุดท้าย
            _weather == null ? 
            null : 
            Column( 
              children: [
                Text(
                  _weather!.place, // ! เป็นการประกาศว่า weather จะต้องมีค่า
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge, // ใช้ Theme เป็น Style
                ),
                const SizedBox(height: 20,), // เว้นระยะด้วยการคั่นด้วย SizedBox
                Text(
                  '${_weather!.temp} ℃',
                  style: Theme.of(context).textTheme.displayLarge
                ),
                const SizedBox(height: 20,),
                Text(
                  _weather!.condition,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 20,),
                Image.network(_weather!.symbol)
              ]
          )
        ),
        FilledButton(
          onPressed: () {
            showDialog( // กำหนดให้มี pop context เพื่อให้มี dialog (หน้าสีเทาๆ) เมื่อกดปุ่ม Refresh
              context: context, 
              builder: (context) {
                _progress = true;
                return const Dialog(
                  backgroundColor: Colors.transparent, // ทำ background ให้โปร่งใส
                  child: Center( // wrap ด้วย center
                    child: CircularProgressIndicator() // สร้างวงกลม
                  )
                );
              }
            );
            updateReport();
          },
          child: const Text('Refresh')
        ) // เพิ่มปุ่ม Refresh
      ], // ใส่สมาชิก Widget ได้หลายตัว
    ); // Column ใกล้เคียงกับเคียงกับ Container เรียงจากบนลงล่างตามแนวตั้ง
  }
}