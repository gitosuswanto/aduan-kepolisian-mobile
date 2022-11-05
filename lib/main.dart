import 'package:aduan/app.dart';
import 'package:aduan/pages.dart';
import 'package:aduan/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:aduan/data/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  String email = await dbHelper.getDataByKey('email');
  
  runApp(App(home: email.isEmpty ? const Login() : const Pages()));
}
