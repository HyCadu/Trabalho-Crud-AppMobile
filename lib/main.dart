import 'package:flutter/material.dart';
import 'views/player_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Players e Partidas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlayerListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}