import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class JenisGen {
  jenisAduanGenerator({required String jenis}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Ionicons.warning_outline,
            size: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            jenis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}