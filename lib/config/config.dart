import 'package:aduan/pages/aduan.dart';
import 'package:aduan/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../pages/home.dart';

class Config {
  final String _title = 'Aduan Kepolisian';

  final Color _color = Colors.indigo;
  final Color _colorActive = Colors.indigo[500]!;

  final String _baseUrl = 'https://ad.ready.my.id/';
  late final String _apiUrl = '${_baseUrl}api/';

  final List<Map<String, dynamic>> _menu = [
    {
      'title': 'Home',
      'icon': Ionicons.home_outline,
      'active': Ionicons.home,
      'page': Home()
    },
    {
      'title': 'Aduan',
      'icon': Ionicons.warning_outline,
      'active': Ionicons.warning,
      'page': Aduan()
    },
    {
      'title': 'Profile',
      'icon': Ionicons.person_circle_outline,
      'active': Ionicons.person_circle,
      'page': Profile()
    },
  ];

  // Getter
  String get getTitle => _title;

  Color get getColor => _color;
  Color get getColorActive => _colorActive;

  String get getBaseUrl => _baseUrl;
  String get getApiUrl => _apiUrl;

  List<Map<String, dynamic>> get getMenu => _menu;
}
