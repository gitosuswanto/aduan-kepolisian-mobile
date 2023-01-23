import 'package:aduan/pages.dart';
import 'package:aduan/pages/custom_password.dart';
import 'package:aduan/pages/login.dart';
import 'package:aduan/pages/register.dart';
import 'package:aduan/pages/reset_password.dart';
import 'package:aduan/pages/tambah_aduan.dart';
import 'package:flutter/material.dart';
import 'package:aduan/config/config.dart';

class App extends StatefulWidget {
  final home;
  const App({super.key, required this.home});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Config().getTitle,
      theme: ThemeData(
        primarySwatch: Config().getColor as MaterialColor,
      ),
      home: widget.home,
      routes: {
        'pages': (context) => const Pages(),
        'login': (context) => const Login(),
        'register': (context) => const Register(),
        'tambah-aduan': (context) => const TambahAduan(),
        'reset-password': (context) => const ResetPassword(),
        'custom-password': (context) => const CustomPassword(),
      },
    );
  }
}
