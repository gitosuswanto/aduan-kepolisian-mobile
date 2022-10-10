import 'package:flutter/material.dart';

class StatusGen extends StatelessWidget {
  const StatusGen({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    late Color _color;

    if (status == 'belum diproses') {
      _color = Colors.orangeAccent;
    } else if (status == 'dalam proses') {
      _color = Colors.blueAccent;
    } else if (status == 'selesai') {
      _color = Colors.greenAccent;
    } else if (status == 'dibatalakan') {
      _color = Colors.redAccent;
    } else {
      _color = Colors.black;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
