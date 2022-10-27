import 'package:aduan/pages.dart';
import 'package:aduan/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:aduan/config/config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Config().getTitle,
      theme: ThemeData(
        primarySwatch: Config().getColor as MaterialColor,
      ),
      home: const Pages(),
    );
  }
}
