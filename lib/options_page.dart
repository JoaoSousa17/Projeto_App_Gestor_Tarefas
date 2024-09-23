import 'package:flutter/material.dart';
import 'tarefas_page.dart';
import 'dias_anteriores_page.dart';
import 'pomodoro_page.dart';
import 'bottom_menu.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Aqui você irá navegar para a página de Preferências quando ela for criada
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Página de Preferências em desenvolvimento')),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Divider(color: Colors.grey[700]),
            ListTile(
              leading: Icon(Icons.timer_outlined, color: Colors.white),
              title: Text('Pomodoro', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PomodoroPage()),
                );
              },
            ),
            Divider(color: Colors.grey[700]),
            // Adicione mais opções de menu aqui, se necessário
          ],
        ),
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomMenu(currentIndex: 3),
    );
  }
}
