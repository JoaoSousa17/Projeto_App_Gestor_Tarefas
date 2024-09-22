import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'top_menu.dart';
import 'options_page.dart';
import 'tarefas_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Tarefas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: TarefasPage(),
    );
  }
}
