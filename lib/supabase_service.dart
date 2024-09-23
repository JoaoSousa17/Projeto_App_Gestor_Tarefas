import 'package:supabase/supabase.dart';

class SupabaseService {
  final SupabaseClient supabaseClient;

  SupabaseService()
      : supabaseClient = SupabaseClient(
          'https://ibglzcpslsenjpstxepd.supabase.co',
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImliZ2x6Y3BzbHNlbmpwc3R4ZXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY5MTkyMjcsImV4cCI6MjA0MjQ5NTIyN30.02tNWMqfR7cy2PvcD0HpABOHN6ZNwxHh5mnHoIGGVh8',
        );

  Map<String, dynamic> _normalizarDadosDiarios(Map<String, dynamic> dados) {
    return {
      ...dados,
      'tarefas_realizadas': (dados['tarefas_realizadas'] as List<dynamic>).map((tarefa) => {
        'tarefa_id': tarefa['tarefa_id'].toString(),
        'pontuacao': tarefa['pontuacao'],
      }).toList(),
    };
  }

  Future<Map<String, dynamic>> verificarOuCriarDadosDiarios() async {
    final hoje = DateTime.now().toIso8601String().split('T')[0];
    try {
      final response = await supabaseClient
          .from('dados_diarios')
          .select()
          .eq('data', hoje)
          .maybeSingle();
      
      if (response == null) {
        final novaEntrada = await supabaseClient
            .from('dados_diarios')
            .insert({
              'data': hoje,
              'tarefas_realizadas': [],
            })
            .select()
            .single();
        return _normalizarDadosDiarios(novaEntrada);
      }
      return _normalizarDadosDiarios(response);
    } catch (e) {
      print('Erro ao verificar ou criar dados diários: $e');
      return _normalizarDadosDiarios({'data': hoje, 'tarefas_realizadas': []});
    }
  }

  Future<Map<String, dynamic>> buscarDadosDiarios(String data) async {
    try {
      final response = await supabaseClient
          .from('dados_diarios')
          .select()
          .eq('data', data)
          .single();
      return _normalizarDadosDiarios(response);
    } catch (e) {
      print('Erro ao buscar dados diários para $data: $e');
      return _normalizarDadosDiarios({'data': data, 'tarefas_realizadas': [], 'pontuacao_total': 0});
    }
  }

   Future<int> atualizarPontuacaoPerfil(int pontuacaoDelta) async {
    try {
      final perfil = await buscarPerfil();
      if (perfil.isEmpty) {
        throw Exception('Perfil não encontrado');
      }
      int novaPontuacao = (perfil['pontuacao'] ?? 0) + pontuacaoDelta;
      await supabaseClient
          .from('perfil')
          .update({'pontuacao': novaPontuacao})
          .eq('id', perfil['id']);
      return novaPontuacao;
    } catch (e) {
      print('Erro ao atualizar pontuação do perfil: $e');
      rethrow;
    }
  }

  Future<void> atualizarTarefasRealizadas(String data, List<Map<String, dynamic>> tarefasRealizadas, int pontuacaoDelta) async {
    try {
      await supabaseClient
          .from('dados_diarios')
          .update({
            'tarefas_realizadas': tarefasRealizadas.map((t) => {
              'tarefa_id': t['tarefa_id'].toString(),
              'pontuacao': t['pontuacao'],
            }).toList(),
          })
          .eq('data', data);
      
      await atualizarPontuacaoPerfil(pontuacaoDelta);
    } catch (e) {
      print('Erro ao atualizar tarefas realizadas e pontuação: $e');
      rethrow;
    }
  }

  int _calcularPontuacaoTotal(List<dynamic> tarefasRealizadas) {
    return tarefasRealizadas.fold(0, (sum, tarefa) => sum + (tarefa['pontuacao'] as int? ?? 0));
  }

  Future<List<Map<String, dynamic>>> buscarDadosUltimos7Dias() async {
    final hoje = DateTime.now();
    final seteDiasAtras = hoje.subtract(Duration(days: 6));
    try {
      final response = await supabaseClient
          .from('dados_diarios')
          .select()
          .gte('data', seteDiasAtras.toIso8601String().split('T')[0])
          .lte('data', hoje.toIso8601String().split('T')[0])
          .order('data', ascending: false);

      return (response as List<dynamic>).map((dados) {
        Map<String, dynamic> dadosNormalizados = _normalizarDadosDiarios(dados);
        int pontuacaoTotal = _calcularPontuacaoTotal(dadosNormalizados['tarefas_realizadas']);
        dadosNormalizados['pontuacao_total'] = pontuacaoTotal;
        return dadosNormalizados;
      }).toList();
    } catch (e) {
      print('Erro ao buscar dados dos últimos 7 dias: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> buscarPerfil() async {
    try {
      final response = await supabaseClient
          .from('perfil')
          .select()
          .single();
      return response ?? {};
    } catch (e) {
      print('Erro ao buscar perfil: $e');
      return {};
    }
  }

  Future<void> adicionarTarefa(String nome, String categoria, int pontuacao) async {
    try {
      await supabaseClient.from('tarefas').insert({
        'nome': nome,
        'categoria': categoria,
        'pontuacao': pontuacao,
        'status': true,
      });
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
      rethrow;
    }
  }

  Future<void> removerTarefa(String id) async {
    try {
      await supabaseClient.from('tarefas').delete().eq('id', id);
    } catch (e) {
      print('Erro ao remover tarefa: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscarTarefasDisponiveis() async {
    try {
      final response = await supabaseClient
          .from('tarefas')
          .select()
          .eq('status', true)
          .order('nome', ascending: true);

      return (response as List<dynamic>).map((item) {
        return Map<String, dynamic>.from(item).map((key, value) {
          if (key == 'id') {
            return MapEntry(key, value.toString());
          }
          return MapEntry(key, value);
        });
      }).toList();
    } catch (e) {
      print('Erro ao buscar tarefas disponíveis: $e');
      return [];
    }
  }
}