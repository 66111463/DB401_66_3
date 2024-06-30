import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  final String gameId;
  final String challenger;
  final Function onAccept;

  const Request({
   required this.gameId,
   required this.challenger,
   required this.onAccept,
   super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(challenger), // เพิ่มชื่อคนที่ขอเล่น
      trailing: FilledButton( // เพิ่มหางเป็นปุ่มเป็นคำว่า Accpet
        onPressed: () => onAccept(gameId), // ฟังก์ชั่นเบรรทัดดียวใช้ =>
        child: const Text('Accept')
      ),
    );
  }
}