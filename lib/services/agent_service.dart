import 'dart:math';
import '../models/models.dart';
import 'local_data_service.dart';

/// Serviço de Agente IA que ajuda usuários a encontrar matches de habilidades
/// e fornece recomendações personalizadas na plataforma Laços.
class AgentService {
  static final AgentService _instance = AgentService._internal();
  factory AgentService() => _instance;
  AgentService._internal();

  final LocalDataService _dataService = LocalDataService();
  final Random _random = Random();

  /// Como o agente funciona:
  /// 1. Analisa o perfil do usuário e suas habilidades
  /// 2. Busca por usuários com habilidades complementares
  /// 3. Calcula compatibilidade baseada em interesses mútuos
  /// 4. Fornece recomendações personalizadas e explicações
  
  /// Encontra matches de habilidades para um usuário específico
  List<SkillMatch> encontrarMatches(String userId) {
    final usuario = _dataService.usuarios.firstWhere(
      (u) => u.id == userId,
      orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
    );

    if (usuario.id.isEmpty) return [];

    final matches = <SkillMatch>[];
    final outrosUsuarios = _dataService.usuarios.where((u) => u.id != userId);

    for (final outroUsuario in outrosUsuarios) {
      final compatibilidade = _calcularCompatibilidade(usuario, outroUsuario);
      
      if (compatibilidade > 0.3) { // Threshold mínimo de 30%
        final match = SkillMatch(
          usuarioId: outroUsuario.id,
          nomeUsuario: outroUsuario.nome,
          compatibilidade: compatibilidade,
          habilidadesComplementares: _encontrarHabilidadesComplementares(
            usuario, 
            outroUsuario
          ),
          explicacao: _gerarExplicacaoMatch(usuario, outroUsuario, compatibilidade),
        );
        matches.add(match);
      }
    }

    // Ordena por compatibilidade (maior primeiro)
    matches.sort((a, b) => b.compatibilidade.compareTo(a.compatibilidade));
    
    return matches.take(10).toList(); // Retorna top 10 matches
  }

  /// Gera recomendações personalizadas de habilidades para aprender
  List<SkillRecommendation> gerarRecomendacoes(String userId) {
    final usuario = _dataService.usuarios.firstWhere(
      (u) => u.id == userId,
      orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
    );

    if (usuario.id.isEmpty) return [];

    final recomendacoes = <SkillRecommendation>[];
    final habilidadesPopulares = _obterHabilidadesPopulares();
    final habilidadesUsuario = usuario.habilidades.map((h) => h.nome.toLowerCase()).toSet();

    for (final habilidade in habilidadesPopulares) {
      if (!habilidadesUsuario.contains(habilidade.toLowerCase())) {
        final pontuacao = _calcularPontuacaoRecomendacao(usuario, habilidade);
        
        if (pontuacao > 0.4) { // Threshold mínimo de 40%
          final recomendacao = SkillRecommendation(
            nomeHabilidade: habilidade,
            pontuacao: pontuacao,
            razao: _gerarRazaoRecomendacao(usuario, habilidade),
            usuariosQueEnsinam: _encontrarUsuariosQueEnsinam(habilidade),
          );
          recomendacoes.add(recomendacao);
        }
      }
    }

    recomendacoes.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));
    return recomendacoes.take(5).toList(); // Top 5 recomendações
  }

  /// Fornece dicas personalizadas do agente para o usuário
  List<String> gerarDicasPersonalizadas(String userId) {
    final usuario = _dataService.usuarios.firstWhere(
      (u) => u.id == userId,
      orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
    );

    if (usuario.id.isEmpty) return [];

    final dicas = <String>[];

    // Analisa perfil do usuário e gera dicas relevantes
    if (usuario.habilidades.isEmpty) {
      dicas.add("💡 Comece adicionando suas habilidades no perfil para encontrar matches perfeitos!");
    } else if (usuario.habilidades.length < 3) {
      dicas.add("⭐ Adicione mais habilidades ao seu perfil para aumentar suas chances de encontrar parceiros!");
    }

    final matches = encontrarMatches(userId);
    if (matches.isNotEmpty) {
      dicas.add("🎯 Você tem ${matches.length} matches potenciais! Que tal entrar em contato?");
    }

    dicas.addAll([
      "🤝 Seja específico sobre o que você pode ensinar e o que deseja aprender",
      "📅 Mantenha horários flexíveis para facilitar o agendamento de trocas",
      "💬 Uma boa comunicação é a chave para trocas bem-sucedidas",
    ]);

    return dicas.take(3).toList();
  }

  /// Calcula compatibilidade entre dois usuários (0.0 a 1.0)
  double _calcularCompatibilidade(Usuario usuario1, Usuario usuario2) {
    if (usuario1.habilidades.isEmpty || usuario2.habilidades.isEmpty) {
      return 0.0;
    }

    // Verifica se há habilidades complementares
    final habilidades1 = usuario1.habilidades.map((h) => h.nome.toLowerCase()).toSet();
    final habilidades2 = usuario2.habilidades.map((h) => h.nome.toLowerCase()).toSet();

    // Busca intersecções (interesses mútuos)
    final interessesComuns = habilidades1.intersection(habilidades2).length;
    final habilidadesDiferentes = habilidades1.union(habilidades2).length - interessesComuns;

    // Fórmula de compatibilidade: valoriza diversidade e alguns interesses comuns
    final diversidade = habilidadesDiferentes.toDouble() / (habilidades1.length + habilidades2.length);
    final comunidade = interessesComuns.toDouble() / max(habilidades1.length, habilidades2.length);

    return (diversidade * 0.7) + (comunidade * 0.3);
  }

  /// Encontra habilidades complementares entre dois usuários
  List<String> _encontrarHabilidadesComplementares(Usuario usuario1, Usuario usuario2) {
    final habilidades1 = usuario1.habilidades.map((h) => h.nome).toSet();
    final habilidades2 = usuario2.habilidades.map((h) => h.nome).toSet();

    // Retorna habilidades que um tem e o outro não
    final complementares = <String>[];
    complementares.addAll(habilidades1.difference(habilidades2));
    complementares.addAll(habilidades2.difference(habilidades1));

    return complementares.take(3).toList();
  }

  /// Gera explicação do match baseada na compatibilidade
  String _gerarExplicacaoMatch(Usuario usuario1, Usuario usuario2, double compatibilidade) {
    final complementares = _encontrarHabilidadesComplementares(usuario1, usuario2);
    
    if (compatibilidade > 0.8) {
      return "Match perfeito! Vocês têm habilidades muito complementares: ${complementares.take(2).join(', ')}";
    } else if (compatibilidade > 0.6) {
      return "Ótima compatibilidade! Podem trocar conhecimentos em: ${complementares.take(2).join(', ')}";
    } else {
      return "Boa compatibilidade para troca de: ${complementares.take(1).join(', ')}";
    }
  }

  /// Obtém lista das habilidades mais populares na plataforma
  List<String> _obterHabilidadesPopulares() {
    final contadorHabilidades = <String, int>{};
    
    for (final usuario in _dataService.usuarios) {
      for (final habilidade in usuario.habilidades) {
        final nome = habilidade.nome.toLowerCase();
        contadorHabilidades[nome] = (contadorHabilidades[nome] ?? 0) + 1;
      }
    }

    final habilidadesOrdenadas = contadorHabilidades.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return habilidadesOrdenadas.map((e) => e.key).take(20).toList();
  }

  /// Calcula pontuação de recomendação para uma habilidade específica
  double _calcularPontuacaoRecomendacao(Usuario usuario, String habilidade) {
    // Fatores considerados:
    // 1. Popularidade da habilidade
    // 2. Complementaridade com habilidades existentes do usuário
    // 3. Disponibilidade de professores

    final popularidade = _obterPopularidadeHabilidade(habilidade);
    final complementaridade = _calcularComplementaridade(usuario, habilidade);
    final disponibilidade = _obterDisponibilidadeProfessores(habilidade);

    return (popularidade * 0.3) + (complementaridade * 0.5) + (disponibilidade * 0.2);
  }

  /// Calcula popularidade de uma habilidade (0.0 a 1.0)
  double _obterPopularidadeHabilidade(String habilidade) {
    final total = _dataService.usuarios.length;
    if (total == 0) return 0.0;

    final comHabilidade = _dataService.usuarios.where(
      (u) => u.habilidades.any((h) => h.nome.toLowerCase() == habilidade.toLowerCase())
    ).length;

    return comHabilidade.toDouble() / total;
  }

  /// Calcula complementaridade de uma habilidade com perfil do usuário
  double _calcularComplementaridade(Usuario usuario, String habilidade) {
    // Habilidades relacionadas por categoria (simulado)
    final categorias = {
      'tecnologia': ['programação', 'design', 'marketing digital'],
      'idiomas': ['inglês', 'espanhol', 'francês'],
      'artes': ['desenho', 'música', 'fotografia'],
      'culinária': ['cozinha', 'panificação', 'confeitaria'],
    };

    for (final categoria in categorias.entries) {
      if (categoria.value.any((h) => h.toLowerCase().contains(habilidade.toLowerCase()))) {
        // Verifica se usuário tem outras habilidades da mesma categoria
        final temHabilidadeCategoria = usuario.habilidades.any(
          (h) => categoria.value.any((cat) => cat.toLowerCase().contains(h.nome.toLowerCase()))
        );
        return temHabilidadeCategoria ? 0.8 : 0.4;
      }
    }

    return 0.5; // Neutro se não encontrar categoria
  }

  /// Obtém disponibilidade de professores para uma habilidade
  double _obterDisponibilidadeProfessores(String habilidade) {
    final professores = _dataService.usuarios.where(
      (u) => u.habilidades.any((h) => h.nome.toLowerCase() == habilidade.toLowerCase())
    ).length;

    return min(professores.toDouble() / 5, 1.0); // Máximo 1.0 quando há 5+ professores
  }

  /// Gera razão para recomendação de habilidade
  String _gerarRazaoRecomendacao(Usuario usuario, String habilidade) {
    final complementaridade = _calcularComplementaridade(usuario, habilidade);
    
    if (complementaridade > 0.7) {
      return "Combina perfeitamente com suas habilidades atuais";
    } else if (complementaridade > 0.5) {
      return "Pode complementar bem seu perfil de habilidades";
    } else {
      return "Habilidade popular e versátil para aprender";
    }
  }

  /// Encontra usuários que ensinam uma habilidade específica
  List<String> _encontrarUsuariosQueEnsinam(String habilidade) {
    return _dataService.usuarios
        .where((u) => u.habilidades.any(
          (h) => h.nome.toLowerCase() == habilidade.toLowerCase())
        )
        .map((u) => u.nome)
        .take(3)
        .toList();
  }
}

/// Modelo para representar um match de habilidades
class SkillMatch {
  final String usuarioId;
  final String nomeUsuario;
  final double compatibilidade;
  final List<String> habilidadesComplementares;
  final String explicacao;

  SkillMatch({
    required this.usuarioId,
    required this.nomeUsuario,
    required this.compatibilidade,
    required this.habilidadesComplementares,
    required this.explicacao,
  });
}

/// Modelo para representar uma recomendação de habilidade
class SkillRecommendation {
  final String nomeHabilidade;
  final double pontuacao;
  final String razao;
  final List<String> usuariosQueEnsinam;

  SkillRecommendation({
    required this.nomeHabilidade,
    required this.pontuacao,
    required this.razao,
    required this.usuariosQueEnsinam,
  });
}