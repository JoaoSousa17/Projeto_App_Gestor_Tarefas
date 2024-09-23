import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'bottom_menu.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final SupabaseService _supabaseService = SupabaseService();
  final _formKey = GlobalKey<FormState>();
  
  String _nome = '';
  String _email = '';
  String _fotoUrl = '';

  @override
  void initState() {
    super.initState();
    _carregarDadosPerfil();
  }

  Future<void> _carregarDadosPerfil() async {
    final perfil = await _supabaseService.buscarPerfil();
    setState(() {
      _nome = perfil['nome'] ?? '';
      _email = perfil['email'] ?? '';
      _fotoUrl = perfil['avatar_url'] ?? '';
    });
  }

  Future<void> _salvarPerfil() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _supabaseService.atualizarPerfil(_nome, _email, _fotoUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar perfil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _fotoUrl.isNotEmpty ? NetworkImage(_fotoUrl) : null,
                  child: _fotoUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _nome,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value!.isEmpty ? 'Por favor, insira seu nome' : null,
                  onSaved: (value) => _nome = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) return 'Por favor, insira seu email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _fotoUrl,
                  decoration: InputDecoration(
                    labelText: 'URL da Foto',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isNotEmpty && !Uri.tryParse(value)!.hasAbsolutePath) {
                      return 'Por favor, insira uma URL válida';
                    }
                    return null;
                  },
                  onSaved: (value) => _fotoUrl = value!,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text('Salvar Alterações', style: TextStyle(color: Colors.white)),
                  onPressed: _salvarPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
}
