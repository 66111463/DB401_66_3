import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _playername; // การใช้ 'late' หมายถึงจะมีค่าทีหลัง ต่าจาก '?' ที่บ่งชี้ว่าเป็นค่าว่างได้
  late String _password;
  bool _ready = false;
  
  @override // ติดต่อกับ Firebase แบบ Asynchronous
  void initState() {
    Firebase.initializeApp()
    .whenComplete(() {
      setState(() {
        _ready = true; // ถ้าติดต่อกับ Firebase ได้ _ready จะเป็น ture
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void gotoChallenge() { // ฟังก์ชั่นตัวเปลี่ยนหน้า
      Navigator.pushReplacementNamed(context, 'challenge'); // การเพิ่มหน้าคือ push และมี Relacement จะไม่สามารถกลับไปหน้าเก่าได้ และหากเป็นหน้าที่สร้างเอาไว้แล้วจะมี Named
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // ครอบด้วย SingleChildScrollView เพื่อไม่ให้ขีดเหลือมาบังหน้าและสามาร Scorll ได้
          child: Padding(
            padding: const EdgeInsets.all(24.0), // ครอบด้วย pedding กำหนดขนาดขอบ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    _password = value;
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
                const SizedBox(height: 24,),
                FilledButton(
                  onPressed: _ready ? () async { // ฟังก์ชั่นเป็น await จึงต้องมี async
                    try { // เพิ่มก้อน try - catch
                      await FirebaseAuth.instance.signInWithEmailAndPassword( // ฟังก์ชั่นในการ User Login
                        email: '$_playername@tictactoe.com', // รับ username เป็น email // $_ เป็นตัวแปรของ playername
                        password: _password
                      );
                      gotoChallenge();
                    } on FirebaseAuthException catch (e) { // เพื่อเข้า catch หากพบปัญหา
                      if (!context.mounted) return; // ถ้า context ยังไม่ถูกเซ็ต (mount) ให้ return สั่งจบงานทันที
                        ScaffoldMessenger.of(context).showSnackBar( // แสดง SnackBar
                          SnackBar(
                            content: Text(e.code), // ข้อความที่ให้แสดง
                            duration: const Duration(seconds: 10), // แสดง SnackBar 10 วินาที
                          )
                        );
                      } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          duration: const Duration(seconds: 10),
                        )
                      );
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder()
                  ),
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 8), // สร้างอีก Box เป็นปุ่มข้อความลิ้งค์ให้กับผู้เล่นใหม่
                TextButton(
                  onPressed: _ready // ถ้าเงื่อนไขเป็น ready ติดต่อ firebase ได้ จะสามารถกดให้ไปยังหน้า register ได้
                  ? () => Navigator.pushNamed(context, 'register') // pushNamed สามารถย้อนกลับหน้าเดิมได้ 
                  : null,
                  child: const Text('New Player Click Here!'),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}