import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/tile.dart';

class Game extends StatefulWidget {
  final String id;

  const Game({required this.id, super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool _done = false; // ตัวแปรสถานะของเกมว่าจบเกมหรือยัง
  String _symbol = '_'; // สัญลักษณ์เช่นผู้เล่น O หรือ X
  String _status = 'C'; // C: challenge, P: playing, D: draw, O: O win, X: X win
  bool _isTurn = false; // ตัวแปรเกี่ยวกับ Turn ของ...
  List<List<String>> _filled = [
    ['_', '_', '_'], // ตาราง 9 แถว '_' เป็นค่าว่าง
    ['_', '_', '_'],
    ['_', '_', '_'],
  ];
  late DocumentReference _game; // Document ที่อยู่บน CloudFireStore

  String _gameTitle() { // ฟังก์ชั่นของเกม
    if(_done) {
      if(_status == 'D') {
        return 'Draw';
      } else if(_status == _symbol) {
        return 'You win';
      } else {
        return 'You lost';
      }
    } else {
      return 'You are $_symbol';
    }
  }

  Color _gameBackground() {
    if(_status == 'D') { // กำหนดฟังก์ชั่นของสถานะของผู้เล่นในแบบต่างๆ
      return Colors.yellow;
    } else if(_status == 'P' || _status == 'C') {
      return Colors.blueGrey;
    } else if(_status == _symbol) {
      return Colors.green;
    }
    return Colors.red;
  }

  bool _winByRow() { // ฟังก์ชั่นที่บ่งบอกว่าชนะหรือยังไม่ชนะ โดยเช็คตามแถวตามกติกาของ X/O
    for (var row in _filled) { // เอาสมาชิกที่อยู่ใน _list เข้ามาอยู่ในตัวแปร row
      var players = <String>{...row}; // การตั้งค่าสมาชิกให้อยู่ในรูปแบบของ Set ที่จะต้องมีค่าไม่ซ้ำกัน
      if (players.length == 1 && players.first == _symbol) { // ทำฟังก์ชั่นเช็คแพ้-ชนะ โดยเช็คสมาชิกว่าซ้ำกันหรือไม่
        return true;
      }
    }
    return false;
  }

  bool _winByColumn() { // ตรวจสอบว่าชนะหรือไม่โดยดูตาม Column
    for (var col = 0; col < 3; col++) { // แต่ละรอบเริ่มต้นที่ 0-2
      var players = <String>{for (var row in [0,1,2]) _filled[row][col]}; // ไล่ลำดับโดยใส่ค่าตัวเลขจาก แถว และ column
      if (players.length == 1 && players.first == _symbol) {
        return true;
      }
    }
    return false;
  }

  bool _winByDiagonal() { // ตรวจสอบว่าชนะแนวทแยงหรือไม่
    var listOfPlayers = <Set<String>>[]; // สร้าง list เปล่าๆ โดยให้เป็น list ของ Set โดย Set เป็นของ String
    listOfPlayers.add({_filled[0][0],_filled[1][1],_filled[2][2]}); // แนวทแยงที่ 1
    listOfPlayers.add({_filled[0][2],_filled[1][1],_filled[2][0]}); // แนวทแยงที่ 2
    for (var players in listOfPlayers) {
      if (players.length == 1 && players.first == _symbol) {
        return true;
      }
    }
    return false;
  }

  void _checkResult(int row, int col) { // ฟังก์ชั่นที่คอยรับค่าจากฟังก์ชั่นด้านบนเพื่อรับผลลัพธ์
    if(!_done && _isTurn && _filled[row][col]=='_') { // รับ Result ต่อเมื่อเกมยังไม่จบและเป็นตาของเราและค่า row + cloumn ต้องไม่ใช่ค่าว่าง
      setState(() {
        _isTurn = false;
        _filled[row][col] = _symbol;
        String filledString = _filled[0].join('') + _filled[1].join('') + _filled[2].join(''); // เอาตัวสมาชิกมาเชื่อมกันและทำ concat
        if(_winByRow() || _winByColumn() || _winByDiagonal()) { // ถ้ามีการชนะแบบใดแบบหนึ่งให้เกม update ว่าชนะทันที ถ้าไม่ตรงเงื่อนไขจะเท่ากับเกมยังเล่นอยู่
          _game.update({'filled': filledString, 'status': _symbol});
        } else {
          if(filledString.contains('_')) { // ถ้า 9 ช่องยังไม่เต็มคือเกมยังเล่นอยู่ให้เปลี่ยน Turn
            _game.update({'filled': filledString, 'turn': _symbol == 'O' ? 'X' : 'O'});
          } else {
            _game.update({'filled': filledString, 'status': 'D'}); // ถ้าค่าทั้ง 9 ช่องเต็มคือยังไม่ชนะ และให้ Update เป็นเกมเสมอ
          }
        }
      });
    }
  }

  @override
  void initState() { // สร้าง initState เพื่อกำหนดค่าครั้งเดียว โดยดึงข้อมูลจาก FireStore
    String playerName = FirebaseAuth.instance.currentUser!.email!; // '!' คือการบ่งชี้ว่ามีค่าแน่ๆ ไม่ใช่ค่าว่าง
    playerName = playerName.substring(0, playerName.length - 14); // ตัดตัวอักษรออกไป 14 ตัวท้าย ตั้งแต่ @tictactoe.com
    _game = FirebaseFirestore.instance.collection('games').doc(widget.id); // ให้เกมติดต่อกับฐานข้อมูลจาก FireStore
    _game.get().then((value) { // .get หมายถึงการดึงเนื้อหามาใช้
      setState(() {
        _symbol = playerName == value['player_o'] ? 'O' : 'X';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void gotoChallenge() {
      Navigator.pushReplacementNamed(context, 'challenge');
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: _game.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        DocumentSnapshot data = snapshot.requireData;
        _isTurn = data['turn'] == _symbol;
        String filledString = data['filled'];
        _filled = [
          filledString.substring(0, 3).split(''),
          filledString.substring(3, 6).split(''),
          filledString.substring(6).split(''),
        ];
        _status = data['status'];
        _done = 'DOX'.contains(_status);
        return Scaffold(
          backgroundColor: _gameBackground(),
          appBar: AppBar(
            title: const Text('Tic-Tac-Toe'),
            actions: [
              IconButton(
                icon: Icon(_done ? Icons.table_rows : Icons.flag),
                onPressed: () async {
                  if(!_done) {
                    await _game.update({
                      'status': _symbol == 'O' ? 'X' : 'O',
                    });
                  }
                  gotoChallenge();
                }
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _gameTitle(),
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24,),
              Text(
                _isTurn ? 'Your turn' : 'Opponent',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(row: 0, col: 0, value: _filled[0][0], onTap: _checkResult),
                  Tile(row: 0, col: 1, value: _filled[0][1], onTap: _checkResult),
                  Tile(row: 0, col: 2, value: _filled[0][2], onTap: _checkResult),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(row: 1, col: 0, value: _filled[1][0], onTap: _checkResult),
                  Tile(row: 1, col: 1, value: _filled[1][1], onTap: _checkResult),
                  Tile(row: 1, col: 2, value: _filled[1][2], onTap: _checkResult),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(row: 2, col: 0, value: _filled[2][0], onTap: _checkResult),
                  Tile(row: 2, col: 1, value: _filled[2][1], onTap: _checkResult),
                  Tile(row: 2, col: 2, value: _filled[2][2], onTap: _checkResult),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}