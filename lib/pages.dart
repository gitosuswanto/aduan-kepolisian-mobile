import 'package:aduan/config/config.dart';
import 'package:aduan/data/database_helper.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _selectedIndex = 0;
  final menu = Config().getMenu;
  late String _title = menu[_selectedIndex]['title'];
  String uid = '';

  @override
  void initState() {
    super.initState();
    getUid().then((value) {
      if (value != '') {
        setState(() {
          uid = value;
        });
      }
    });
  }

  Future<String> getUid() {
    final dbHelper = DatabaseHelper.instance;
    final uid = dbHelper.getDataByKey('id');
    return uid;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = menu[index]['title'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: menu[_selectedIndex]['title'] == 'Profile'
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'custom-password');
                  },
                  icon: const Hero(
                    tag: "key-icon",
                    child: Icon(Ionicons.key_sharp),
                  ),
                ),
              ]
            : [],
      ),
      body: AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 200),
        child: menu[_selectedIndex]['page'],
      ),
      floatingActionButton: menu[_selectedIndex]['title'] == 'Aduan' ||
              menu[_selectedIndex]['title'] == 'Home'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'tambah-aduan');
              },
              tooltip: 'Tambah Aduan',
              child: const Icon(Ionicons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        selectedItemColor: Config().getColorActive,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          for (var i = 0; i < menu.length; i++)
            BottomNavigationBarItem(
              label: menu[i]['title'],
              icon: Icon(
                  _selectedIndex == i ? menu[i]['active'] : menu[i]['icon']),
            ),
        ],
      ),
    );
  }
}

class ButtonSearch extends StatelessWidget {
  const ButtonSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Ionicons.search),
    );
  }
}
