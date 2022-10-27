import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ionicons/ionicons.dart';

class TambahAduan extends StatefulWidget {
  const TambahAduan({super.key});

  @override
  State<TambahAduan> createState() => _TambahAduanState();
}

class _TambahAduanState extends State<TambahAduan> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'tambah_aduan',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Ionicons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Tambah Aduan'),
        ),
        body: SafeArea(
          child: Text('Tambah Aduan'),
        ),
      ),
    );
  }
}
