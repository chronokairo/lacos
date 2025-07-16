import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/events_service.dart';

class EventsProvider extends ChangeNotifier {
  final EventsService _eventsService = EventsService();
  
  List<Evento> _events = [];
  List<Evento> _userEvents = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  EventCategory? _selectedCategory;
  DateTime? _selectedDate;

  // Getters
  List<Evento> get events => _filteredEvents;
  List<Evento> get userEvents => _userEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  EventCategory? get selectedCategory => _selectedCategory;
  DateTime? get selectedDate => _selectedDate;

  List<Evento> get _filteredEvents {
    var filtered = List<Evento>.from(_events);
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) =>
        event.titulo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.descricao.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_selectedCategory != null) {
      filtered = filtered.where((event) =>
        event.categoria == _selectedCategory
      ).toList();
    }
    
    if (_selectedDate != null) {
      filtered = filtered.where((event) =>
        event.data.year == _selectedDate!.year &&
        event.data.month == _selectedDate!.month &&
        event.data.day == _selectedDate!.day
      ).toList();
    }
    
    // Sort by date (nearest first)
    filtered.sort((a, b) => a.data.compareTo(b.data));
    
    return filtered;
  }

  // Initialize events
  Future<void> initializeEvents() async {
    _setLoading(true);
    try {
      await loadAllEvents();
    } catch (e) {
      _setError('Erro ao carregar eventos: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load all events
  Future<void> loadAllEvents() async {
    try {
      _events = await _eventsService.getAllEvents();
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar eventos: $e');
    }
  }

  // Load user events
  Future<void> loadUserEvents(String userId) async {
    try {
      _userEvents = await _eventsService.getUserEvents(userId);
      notifyListeners();
    } catch (e) {
      _setError('Erro ao carregar eventos do usuário: $e');
    }
  }

  // Add event
  Future<bool> addEvent(Evento event) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _eventsService.addEvent(event);
      if (result['success']) {
        _events.add(result['event']);
        _userEvents.add(result['event']);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao adicionar evento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update event
  Future<bool> updateEvent(Evento event) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _eventsService.updateEvent(event);
      if (result['success']) {
        final index = _events.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          _events[index] = result['event'];
        }
        
        final userIndex = _userEvents.indexWhere((e) => e.id == event.id);
        if (userIndex != -1) {
          _userEvents[userIndex] = result['event'];
        }
        
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao atualizar evento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove event
  Future<bool> removeEvent(String eventId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _eventsService.removeEvent(eventId);
      if (result['success']) {
        _events.removeWhere((e) => e.id == eventId);
        _userEvents.removeWhere((e) => e.id == eventId);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao remover evento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Join event
  Future<bool> joinEvent(String eventId, String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _eventsService.joinEvent(eventId, userId);
      if (result['success']) {
        // Update local state
        final event = _events.firstWhere((e) => e.id == eventId);
        event.participantes.add(userId);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao participar do evento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Leave event
  Future<bool> leaveEvent(String eventId, String userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _eventsService.leaveEvent(eventId, userId);
      if (result['success']) {
        // Update local state
        final event = _events.firstWhere((e) => e.id == eventId);
        event.participantes.remove(userId);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao sair do evento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search events
  void searchEvents(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(EventCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Filter by date
  void filterByDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedDate = null;
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