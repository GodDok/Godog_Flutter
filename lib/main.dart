import 'package:flutter/material.dart';
import 'package:godog/screens/home/home_screen.dart';
import 'package:godog/screens/start/start_screen.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
// import 'package:godog/screens/login/login_screen.dart';

void main() {
  AuthRepository.initialize(appKey: 'e9c4e407196ea0805fcbd0a3a3606c32');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
