import 'package:flutter/foundation.dart';
import '../services/agent_service.dart';

/// Provider para gerenciar estado do agente IA
class AgentProvider with ChangeNotifier {
  final AgentService _agentService = AgentService();
  
  List<SkillMatch> _matches = [];
  List<SkillRecommendation> _recomendacoes = [];
  List<String> _dicas = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SkillMatch> get matches => _matches;
  List<SkillRecommendation> get recomendacoes => _recomendacoes;
  List<String> get dicas => _dicas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carrega dados do agente para um usuário específico
  Future<void> carregarDadosAgente(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simula processamento IA (em produção seria async)
      await Future.delayed(const Duration(milliseconds: 500));
      
      _matches = _agentService.encontrarMatches(userId);
      _recomendacoes = _agentService.gerarRecomendacoes(userId);
      _dicas = _agentService.gerarDicasPersonalizadas(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar dados do agente: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza recomendações quando perfil do usuário muda
  void atualizarRecomendacoes(String userId) {
    try {
      _recomendacoes = _agentService.gerarRecomendacoes(userId);
      _dicas = _agentService.gerarDicasPersonalizadas(userId);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao atualizar recomendações: $e';
      notifyListeners();
    }
  }

  /// Limpa dados do agente (para uso no logout)
  void limparDados() {
    _matches = [];
    _recomendacoes = [];
    _dicas = [];
    _error = null;
    notifyListeners();
  }
}