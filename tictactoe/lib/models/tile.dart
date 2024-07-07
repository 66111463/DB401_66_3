import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int row; // final เป็นค่าท้ายสุดเปลี่ยนแปลงไม่ได้
  final int col;
  final String value;
  final Function onTap;

  const Tile({
    required this.row,
    required this.col,
    required this.value,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(row, col),
      child: Container(
        width: 92,
        height: 92,
        margin: const EdgeInsets.all(5), // เว้นระยะห่างขอบนอก
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          value == '_' ? ' ' : value,
          style: const TextStyle(fontSize: 72),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}