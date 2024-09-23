import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'tarefas_page.dart';
import 'bottom_menu.dart';

class DiasAnterioresPage extends StatefulWidget {
  @override
  _DiasAnterioresPageState createState() => _DiasAnterioresPageState();
}

class _DiasAnterioresPageState extends State<DiasAnterioresPage> with SingleTickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> dadosUltimos7Dias = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _buscarDadosUltimos7Dias();
  }

  void _buscarDadosUltimos7Dias() async {
    final dados = await _supabaseService.buscarDadosUltimos7Dias();
    setState(() {
      dadosUltimos7Dias = dados;
      _tabController = TabController(length: dados.length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatarData(String data) {
    final partes = data.split('-');
    return '${partes[2]}/${partes[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Dias'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: dadosUltimos7Dias.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.grey[900],
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.blue,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: dadosUltimos7Dias.map((dia) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 50),
                        child: Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatarData(dia['data']),
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, size: 10, color: Colors.yellow),
                                    SizedBox(width: 2),
                                    Text(
                                      '${dia['pontuacao_total']}',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: dadosUltimos7Dias.map((dia) {
                      return SingleChildScrollView(
                        child: _buildDiaContent(dia),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomMenu(currentIndex: 2),
    );
  }

  Widget _buildDiaContent(Map<String, dynamic> dia) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Resumo do Dia ${_formatarData(dia['data'])}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 20, color: Colors.yellow),
                    SizedBox(width: 4),
                    Text(
                      'Pontuação Total: ${dia['pontuacao_total']}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Tarefas Realizadas: ${(dia['tarefas_realizadas'] as List).length}',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.visibility, size: 16),
            label: Text('Ver Detalhes das Tarefas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TarefasPage(data: dia['data']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
