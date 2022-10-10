import 'package:aduan/pages/aduan.dart';
import 'package:aduan/pages/home.dart';
import 'package:aduan/pages/profile.dart';
import 'package:aduan/config/config.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _selectedIndex = 1;
  final menu = Config().getMenu;
  late String _title = menu[_selectedIndex]['title'];

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Aduan(),
    Profile()
  ];

  @override
  void initState() {
    super.initState();
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
          actions: menu[_selectedIndex]['title'] == 'Aduan'
              ? [
                  const ButtonSearch(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Ionicons.filter),
                  ),
                ]
              : [const ButtonSearch()]),
      // _widgetOptions.elementAt(_selectedIndex)
      body: AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 200),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: menu[_selectedIndex]['title'] == 'Aduan' ||
              menu[_selectedIndex]['title'] == 'Home'
          ? FloatingActionButton(
              onPressed: () {},
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
