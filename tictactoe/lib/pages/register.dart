import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> { // ไม่จำเป็นต้องเช็คการเชื่อมต่อกับ Firebase เพราะมาจากหน้า Login ที่มี _ready คอยเช็คให้อยู่แล้ว
  late String _playername;
  late String _password;
  late String _passwordCheck;

  @override
Widget build(BuildContext context) {
    void gotoChallenge() { // ฟังก์ชั่นตัวเปลี่ยนหน้า
      Navigator.pushReplacementNamed(context, 'challenge'); // การเพิ่มหน้าคือ push และมี Relacement จะไม่สามารถกลับไปหน้าเก่าได้ และหากเป็นหน้าที่สร้างเอาไว้แล้วจะมี Named
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Player')
      ), // แสดงข้อความที่อยู่บน AppBar
      body: Center(
        child: SingleChildScrollView( // ครอบด้วย SingleChildScrollView เพื่อไม่ให้ขีดเหลือมาบังหน้าและสามาร Scorll ได้
          child: Padding(
            padding: const EdgeInsets.all(24.0), // ครอบด้วย pedding กำหนดขนาดขอบ
            child: Column(
              children: [
                Image.asset('images/logo.png', height: 100,), // จัดวางรูปภาพ
                const SizedBox(height: 48,), // กำหนดขนาด SizedBox
                TextField( // ทำช่องให้กรอก Username/Password
                  onChanged: (value) { // เมื่อมีการพิมพ์ข้อความลงไปให้บันทึกลงในตัวแปร
                    _playername = value;
                  },
                  keyboardType: TextInputType.name, // เลือก TextInputType ที่เหมาะกับการใช้งาน
                  textAlign: TextAlign.center,
                  decoration: InputDecoration( // ชุดตกแต่ง
                    hintText: 'Enter your player name', // คำใบ้ในการใส่ Text
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                TextField(
                  onChanged: (value) {
                    _password = value; // password ตัวที่ 1 ให้เก็บไว้ในตัวแปร password
                  },
                  obscureText: true, // ตัวบังการพิมพ์ *** ที่ใช้กับการป้อน Password
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                TextField(
                  onChanged: (value) {
                    _passwordCheck = value; // password ตัวที่ 2 ให้เก็บไว้ใน passwordCheck
                  },
                  obscureText: true, // ตัวบังการพิมพ์ *** ที่ใช้กับการป้อน Password
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Retype your password', // ข้อความพิมพ์ password ซ้ำอีกครั้ง
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                ElevatedButton(
                  onPressed: () async {
                    if(_password == _passwordCheck) {
                        try {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword( // ฟังก์ชั่นในการ Create User
                            email: '$_playername@tictactoe.com',
                            password: _password
                          );
                          gotoChallenge();
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.code),
                              duration: const Duration(seconds: 10),
                            )
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              duration: const Duration(seconds: 10),
                            )
                          );
                        }
                      } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password and Retype password are not identical.'),
                          duration: Duration(seconds: 10),
                        )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder()
                  ),
                  child: const Text('Register'),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}