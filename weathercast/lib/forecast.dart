import 'dart:convert'; // bundled package ของ dart แนะนำให้ import เข้ามาก่อนเพื่อไม่ให้เกิดการเขียน package ทับกัน
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http; // ใช้ namespace ด้วย as เพื่อกันปัญหาการเรียกชื่อฟังก์ชั่นซ้ำกัน

import 'location.dart'; // local fucntion
import 'weather.dart'; // local fucntion

Future<Weather> forecast() async {
  const String key = 'b37bf6c569141baf205f3c56d3d1fab5'; // ให้ตัวแปร key เก็บค่า api key // constant เป็นค่าคงที่
  try { // สร้าง blog try-catch เพื่อใช้สำหรับ debug function ได้ เมื่อทราบว่ามีปัญหา
    Position location = await getCurrentLocation();
    Uri api = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&lang=th&appid=$key');
    http.Response response = await http.get( // หากต้องการรอให้จบคำสั่งให้ใส่ await
      api,
      headers: {
        'accept': 'application/json' // กำหนดให้รับ header เป็น json format
      }
    );
    if(response.statusCode == 200) { // == ใช้เพื่อเปรียบเทียบว่าผลลัพธ์ออกมาเป็น status code 200 หรือไม่
      var result = jsonDecode(response.body); // กำหนดตัวแปรในการ Decode JSON format ออกมาเป็น Dart Objects
      var weather = result['weather'][0]; // ดึงค่า weather มาเก็บไว้เป็นตัวแปร
      double temp = result['main']['temp']; // ดึงค่า temp มาเก็บไว้เป็นตัวแปร
      String place = result['name']; // ดึงค่าสถานที่ มาเก็บไว้เป็นตัวแปร
      return Weather(weather, temp, place);
    } else {
      return Future.error(response.toString());
    }
  } catch (e) {
    return Future.error(e.toString());
  }
}