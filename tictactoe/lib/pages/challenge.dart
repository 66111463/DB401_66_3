import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/request.dart';
import 'game.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  late String _playerName; // late ใส่ค่าทีหลังได้
  late CollectionReference _games;
  List<Request> _challenges = [];

  void startGame(String gameId) { // ให้มีระบุ GameID อะไร และใช้ Doc ตัวใด จากนั้นให้ Update
    _games.doc(gameId).update({
      'player_x': _playerName,
      'status': 'P',
    }).whenComplete( // เมื่อเสร็จสิ้นให้เปลี่ยนหน้าเป็นหน้าใหม่ที่ถูกสร้างขึ้น
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Game(id: gameId))) // MaterialPageRoute เป็นการสร้างหน้าใหม่
    );
  }

  @override
  void initState() { // สร้างหน้าจอ Challenge
    _playerName = FirebaseAuth.instance.currentUser!.email!;
    _playerName = _playerName.substring(0, _playerName.length - 14);
    _games = FirebaseFirestore.instance.collection('games');
    _games.where('status', isEqualTo: 'C') // player Status = C (Challenge)
    .where('player_o', isNotEqualTo: _playerName) // player_o ไม่ใช่เรา
    .get().then((value) { // ตัวแปร value เป็นผลลัพธ์ที่รวบรวมมาทั้งหมด
      setState(() {
        _challenges = [
          for(var doc in value.docs) Request(
            gameId: doc.id,
            challenger: doc['player_o'],
            onAccept: startGame,
          )
        ];
      });
    });
    super.initState();
  }

  void gotoLogin() {
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _games.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        QuerySnapshot data = snapshot.requireData;
        _challenges = [
          for (DocumentSnapshot doc in data.docs)
            if (doc['status'] == 'C' && doc['player_o'] != _playerName)
              Request(
                gameId: doc.id,
                challenger: doc['player_o'],
                onAccept: startGame,
              )
        ];
        return Scaffold(
          appBar: AppBar(
            title: const Text('All Challenges'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); // SignOut กลับไปหน้า Login
                  gotoLogin();
                }
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Welcome $_playerName',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Expanded( // ยืดให้เต็มหน้าจอด้วย Expanded
                child: ListView(
                  children: _challenges.isNotEmpty ? 
                  ListTile.divideTiles( //ใส่ Array ไปใน Tile แต่ละช่องด้วย ListTile และใช้ Method เป็น Divide
                    context: context, 
                    tiles: _challenges
                  ).toList() : [],
                ),
              ),
              FilledButton(
                onPressed: () {
                  _games.add({ // ปุ่ม New Game เมื่อกดจะมีการสร้าง Document ใหม่ขึ้นมา
                    'start': FieldValue.serverTimestamp(), // เวลาที่เป็น TimeStamp จาก Firebase
                    'player_o': _playerName, // ใครสร้างเกมเป็น Palyer O
                    'filled': '_________', // filled = '_' ทั้งหมด 9 ช่อง
                    'status': 'C',
                    'turn': Random().nextBool() ? 'O' : 'X', // สุ่มว่าใครจะเป็นคนเริ่มเล่นก่อน
                  }).then(
                    (value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Game(id: value.id))
                    )
                  );
                },
                child: const Text('New Game'),
              ),
            ],
          ),
        );
      }
    );
  }
}