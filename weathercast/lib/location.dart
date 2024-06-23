import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async { // หาก return มี await ฟังก์ชั่นนี้ต้องมี async ด้วย // Future เป็นลักษณะเดียวกับ Promise เป็นการสัญญาว่าจะมีการ Return ค่าอะไรบางอย่างกลับออกมา
  bool serviceEnabled; // boolean เป็นแค่ค่า TRUE หรือ FALSE เท่านั้น
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled(); // เช็ค Servive Geolocator ว่ามีการเปิดอยู่หรือไม่
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission(); // ตรวจสอบ Geolocator ก่อนว่ามี permission หรือไม่
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.'
    ); // หากมีการ Denied ตั้งแต่ตอนติดตั้ง Application ให้แจ้งว่าหากมีการ Denied Permission แบบ Permanently อยู่ ต้องแก้ด้วยการเปิดเข้าหน้า Setting เพื่ออนุญาต
  }

  return await Geolocator.getCurrentPosition();
  // เป็น Method แบบ Asynchronous (ไม่ต้องรอให้จบ function) ได้ผลลัพธ์แบบ Future เพื่อป้องกันการเกิด Deadlocked
}