import 'package:flutter/material.dart';
import 'package:godog/screens/board/board_list_screen.dart';
import 'package:godog/screens/home/home_screen.dart';
import 'package:godog/screens/map/map_screen.dart';
import 'package:godog/screens/start/start_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StartScreen());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MapScreen(),
    BoardListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            label: '분석 리포트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_sharp),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: '커뮤니티',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        iconSize: 30,
      ),
    );
  }
}
