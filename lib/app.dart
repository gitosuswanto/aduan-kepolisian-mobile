import 'package:aduan/pages.dart';
import 'package:flutter/material.dart';
import 'package:aduan/config/config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config().getTitle,
      theme: ThemeData(
        primarySwatch: Config().getColor as MaterialColor,
      ),
      home: const Pages(),
    );
  }
}
