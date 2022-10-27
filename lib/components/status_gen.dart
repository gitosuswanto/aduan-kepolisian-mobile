import 'package:flutter/material.dart';

class StatusGen {
  _genColor(String s) {
    if (s == 'belum diproses') {
      return Colors.orange[300];
    } else if (s == 'dalam proses') {
      return Colors.blue[300];
    } else if (s == 'selesai') {
      return Colors.green[300];
    } else if (s == 'dibatalakan') {
      return Colors.red[300];
    } else {
      return Colors.black;
    }
  }

  bullet({required String status}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: _genColor(status),
        shape: BoxShape.circle,
      ),
    );
  }

  text({required String status}) {
    return Container (
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _genColor(status),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color:
              _genColor(status) == Colors.black ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
