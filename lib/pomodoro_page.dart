import 'package:flutter/material.dart';

class PomodoroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro'),
      ),
      body: Center(
        child: Text(
          'Página de Pomodoro',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
