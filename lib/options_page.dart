import 'package:flutter/material.dart';
import 'tarefas_page.dart';          // Importa a página de Tarefas
import 'dias_anteriores_page.dart'; // Importa a página de Dias Anteriores
import 'pomodoro_page.dart';        // Importa a página de Pomodoro

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opções'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Text(
              'Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 20),

            // Lista de opções
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.white),
              title: Text('Tarefas', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Navegar para a página de Tarefas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TarefasPage()), // TarefasPage a ser implementada
                );
              },
            ),
            Divider(color: Colors.grey[700]),

            ListTile(
              leading: Icon(Icons.calendar_today_outlined, color: Colors.white),
              title: Text('Dias Anteriores', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Navegar para a página de Dias Anteriores
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiasAnterioresPage()), // DiasAnterioresPage a ser implementada
                );
              },
            ),
            Divider(color: Colors.grey[700]),

            ListTile(
              leading: Icon(Icons.timer_outlined, color: Colors.white),
              title: Text('Pomodoro', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Navegar para a página de Pomodoro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PomodoroPage()), // PomodoroPage a ser implementada
                );
              },
            ),
            Divider(color: Colors.grey[700]),
          ],
        ),
      ),
      backgroundColor: Colors.black,  // Fundo escuro para manter o design minimalista e futurista
    );
  }
}
