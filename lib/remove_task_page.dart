import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'bottom_menu.dart';

class RemoveTaskPage extends StatefulWidget {
  @override
  _RemoveTaskPageState createState() => _RemoveTaskPageState();
}

class _RemoveTaskPageState extends State<RemoveTaskPage> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    try {
      final tarefasCarregadas = await _supabaseService.buscarTarefasDisponiveis();
      setState(() {
        tarefas = tarefasCarregadas;
      });
    } catch (e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  void _removerTarefa(String id) async {
    try {
      await _supabaseService.removerTarefa(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarefa removida com sucesso!')),
      );
      _carregarTarefas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover tarefa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remover Tarefa'),
        backgroundColor: Colors.black,
      ),
      body: tarefas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(
                      tarefa['nome'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Pontuação: ${tarefa['pontuacao']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerTarefa(tarefa['id']),
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomMenu(currentIndex: 0),
    );
  }
}