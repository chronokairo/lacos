import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/skills_service.dart';

class SkillsProvider extends ChangeNotifier {
  final SkillsService _skillsService = SkillsService();
  
  List<Habilidade> _userSkills = [];
  List<Habilidade> _allSkills = [];
  List<SkillMatch> _skillMatches = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  SkillCategory? _selectedCategory;

  // Getters
  List<Habilidade> get userSkills => _userSkills;
  List<Habilidade> get allSkills => _filteredSkills;
  List<SkillMatch> get skillMatches => _skillMatches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  SkillCategory? get selectedCategory => _selectedCategory;

  List<Habilidade> get _filteredSkills {
    var filtered = List<Habilidade>.from(_allSkills);
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((skill) =>
        skill.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        skill.descricao.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_selectedCategory != null) {
      filtered = filtered.where((skill) =>
        skill.categoria == _selectedCategory
      ).toList();
    }
    
    return filtered;
  }

  // Initialize skills
  Future<void> initializeSkills(String userId) async {
    _setLoading(true);
    try {
      await loadUserSkills(userId);
      await loadAllSkills();
      await findSkillMatches(userId);
    } catch (e) {
      _setError('Erro ao carregar habilidades: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load user skills
  Future<void> loadUserSkills(String userId) async {
    try {
      _userSkills = await _skillsService.getUserSkills(userId);
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar habilidades do usuário: $e');
    }
  }

  // Load all skills
  Future<void> loadAllSkills() async {
    try {
      _allSkills = await _skillsService.getAllSkills();
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar todas as habilidades: $e');
    }
  }

  // Add skill
  Future<bool> addSkill(Habilidade skill, String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _skillsService.addSkill(skill, userId);
      if (result['success']) {
        _userSkills.add(result['skill']);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao adicionar habilidade: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update skill
  Future<bool> updateSkill(Habilidade skill, String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _skillsService.updateSkill(skill, userId);
      if (result['success']) {
        final index = _userSkills.indexWhere((s) => s.id == skill.id);
        if (index != -1) {
          _userSkills[index] = result['skill'];
          notifyListeners();
        }
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao atualizar habilidade: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove skill
  Future<bool> removeSkill(String skillId, String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _skillsService.removeSkill(skillId, userId);
      if (result['success']) {
        _userSkills.removeWhere((s) => s.id == skillId);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao remover habilidade: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Find skill matches
  Future<void> findSkillMatches(String userId) async {
    try {
      _skillMatches = await _skillsService.findSkillMatches(userId);
      notifyListeners();
    } catch (e) {
      _setError('Erro ao buscar correspondências: $e');
    }
  }

  // Search skills
  void searchSkills(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(SkillCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}