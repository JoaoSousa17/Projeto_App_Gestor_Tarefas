import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'bottom_menu.dart';
import 'add_task_page.dart';
import 'remove_task_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseService _supabaseService = SupabaseService();
  Map<String, dynamic> perfilUsuario = {};

  @override
  void initState() {
    super.initState();
    _buscarPerfil();
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

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.63,
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
                        child: Column(
                          children: [
                            Text(
                              perfilUsuario['nome'] ?? 'Carregando...',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildInfoItem(
                                  icon: Icons.star,
                                  label: 'Pontuação',
                                  value: '${perfilUsuario['pontuacao'] ?? 0}',
                                ),
                                SizedBox(width: 40),
                                _buildInfoItem(
                                  icon: Icons.trending_up,
                                  label: 'Nível',
                                  value: '${perfilUsuario['nivel'] ?? 1}',
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Próximo nível em ${perfilUsuario['pontos_para_proximo_nivel'] ?? 0} pontos',
                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: perfilUsuario['avatar_url'] != null
                              ? NetworkImage(perfilUsuario['avatar_url'])
                              : null,
                          child: perfilUsuario['avatar_url'] == null
                              ? Icon(Icons.person, size: 60, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _buildActionButton(
                  'Editar Perfil',
                  Icons.edit,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    ).then((_) => _buscarPerfil()); // Atualiza o perfil após retornar
                  },
                ),
                _buildActionButton(
                  'Adicionar Tarefa',
                  Icons.add_task,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskPage()),
                    ).then((_) => _buscarPerfil()); // Atualiza o perfil após retornar
                  },
                ),
                _buildActionButton(
                  'Remover Tarefa',
                  Icons.remove_circle_outline,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RemoveTaskPage()),
                    ).then((_) => _buscarPerfil()); // Atualiza o perfil após retornar
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomMenu(currentIndex: 0),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}