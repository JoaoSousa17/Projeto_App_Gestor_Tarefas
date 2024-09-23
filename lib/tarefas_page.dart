import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'options_page.dart';
import 'bottom_menu.dart';

class TarefasPage extends StatefulWidget {
  final String? data;

  const TarefasPage({Key? key, this.data}) : super(key: key);

  @override
  _TarefasPageState createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> with SingleTickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> tarefas = [];
  Map<String, dynamic>? dadosDiarios;
  Map<String, dynamic> perfilUsuario = {};
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _buscarDados();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _buscarDados() async {
    await _buscarPerfil();
    await _buscarTarefas();
    await _buscarDadosDiarios();
  }

  _buscarPerfil() async {
    try {
      final perfil = await _supabaseService.buscarPerfil();
      setState(() {
        perfilUsuario = perfil;
      });
    } catch (e) {
      print('Erro ao buscar perfil: $e');
    }
  }

  _buscarTarefas() async {
    try {
      final response = await _supabaseService.buscarTarefasDisponiveis();
      setState(() {
        tarefas = response;
      });
    } catch (e) {
      print('Erro ao buscar tarefas: $e');
    }
  }

  _buscarDadosDiarios() async {
    try {
      final response = widget.data == null
          ? await _supabaseService.verificarOuCriarDadosDiarios()
          : await _supabaseService.buscarDadosDiarios(widget.data!);
      setState(() {
        dadosDiarios = response;
      });
    } catch (e) {
      print('Erro ao buscar dados diários: $e');
    }
  }

  _mudarStatusTarefa(String id, bool realizada) async {
    try {
      final tarefa = tarefas.firstWhere((t) => t['id'] == id);
      List<Map<String, dynamic>> tarefasRealizadas = 
        List<Map<String, dynamic>>.from(dadosDiarios?['tarefas_realizadas'] ?? []);

      int pontuacaoDelta = 0;

      if (realizada) {
        tarefasRealizadas.add({
          'tarefa_id': id,
          'pontuacao': tarefa['pontuacao'],
        });
        pontuacaoDelta = tarefa['pontuacao'];
      } else {
        tarefasRealizadas.removeWhere((t) => t['tarefa_id'] == id);
        pontuacaoDelta = -tarefa['pontuacao'];
      }

      // Atualizar o estado local imediatamente
      setState(() {
        dadosDiarios?['tarefas_realizadas'] = tarefasRealizadas;
        perfilUsuario['pontuacao'] = (perfilUsuario['pontuacao'] ?? 0) + pontuacaoDelta;
      });

      await _supabaseService.atualizarTarefasRealizadas(
        widget.data ?? DateTime.now().toIso8601String().split('T')[0], 
        tarefasRealizadas,
        pontuacaoDelta
      );

      // Atualizar os dados após a operação no Supabase
      await _buscarDadosDiarios();
      await _buscarPerfil();
    } catch (e) {
      print('Erro ao mudar status da tarefa: $e');
      // Reverter o estado local em caso de erro
      await _buscarDadosDiarios();
      await _buscarPerfil();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar a tarefa. Tente novamente.')),
      );
    }
  }

  Widget _buildTarefaItem(Map<String, dynamic> tarefa, bool realizada) {
    return Dismissible(
      key: Key(tarefa['id']),
      background: Container(
        color: realizada ? Colors.red : Colors.green,
        alignment: realizada ? Alignment.centerRight : Alignment.centerLeft,
        padding: realizada ? EdgeInsets.only(right: 20.0) : EdgeInsets.only(left: 20.0),
        child: Icon(
          realizada ? Icons.cancel : Icons.check,
          color: Colors.white,
        ),
      ),
      direction: realizada ? DismissDirection.endToStart : DismissDirection.startToEnd,
      onDismissed: (direction) {
        _mudarStatusTarefa(tarefa['id'], !realizada);
      },
      child: ListTile(
        title: Text(
          tarefa['nome'],
          style: TextStyle(
            color: Colors.white,
            decoration: realizada ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          'Pontuação: ${tarefa['pontuacao']}',
          style: TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(
            realizada ? Icons.check_circle : Icons.double_arrow,
            color: realizada ? Colors.green : Colors.grey,
          ),
          onPressed: () {
            _mudarStatusTarefa(tarefa['id'], !realizada);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyTaskMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 80,
            color: Colors.yellow,
          ),
          SizedBox(height: 20),
          Text(
            'Parabéns!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Concluíste todas as tarefas de hoje!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

   Widget _buildNoCompletedTasksMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            padding: EdgeInsets.all(20),
            child: Icon(
              Icons.close,
              size: 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Ainda não completaste',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'qualquer tarefa hoje!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Que tal começar agora?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tarefasNaoRealizadas = [];
    List<Map<String, dynamic>> tarefasRealizadas = [];

    if (dadosDiarios != null && dadosDiarios!['tarefas_realizadas'] != null) {
      final tarefasRealizadasIds = (dadosDiarios!['tarefas_realizadas'] as List<dynamic>)
          .map((t) => t['tarefa_id'].toString())
          .toSet();
      
      tarefasNaoRealizadas = tarefas.where((tarefa) => !tarefasRealizadasIds.contains(tarefa['id'])).toList();
      tarefasRealizadas = tarefas.where((tarefa) => tarefasRealizadasIds.contains(tarefa['id'])).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'A Fazer'),
              Tab(text: 'Realizadas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Lista de tarefas não realizadas
                tarefasNaoRealizadas.isEmpty
                    ? _buildEmptyTaskMessage()
                    : ListView.builder(
                        itemCount: tarefasNaoRealizadas.length,
                        itemBuilder: (context, index) => _buildTarefaItem(tarefasNaoRealizadas[index], false),
                      ),
                // Lista de tarefas realizadas
                tarefasRealizadas.isEmpty
                    ? _buildNoCompletedTasksMessage()
                    : ListView.builder(
                        itemCount: tarefasRealizadas.length,
                        itemBuilder: (context, index) => _buildTarefaItem(tarefasRealizadas[index], true),
                      ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomMenu(currentIndex: 1),
    );
  }
}
