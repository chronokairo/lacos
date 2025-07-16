import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class EventsService {
  final StorageService _storageService = StorageService();

  Future<List<Evento>> getAllEvents() async {
    try {
      final events = await _storageService.getAllEvents();
      
      // Load participants for each event
      for (final event in events) {
        final participants = await _storageService.getEventParticipants(event.id);
        event.participantes.clear();
        event.participantes.addAll(participants);
      }
      
      return events;
    } catch (e) {
      throw Exception('Erro ao carregar eventos: $e');
    }
  }

  Future<List<Evento>> getUserEvents(String userId) async {
    try {
      return await _storageService.getUserEvents(userId);
    } catch (e) {
      throw Exception('Erro ao carregar eventos do usuário: $e');
    }
  }

  Future<Map<String, dynamic>> addEvent(Evento event) async {
    try {
      // Validate event data
      if (event.titulo.trim().isEmpty) {
        return {'success': false, 'error': 'Título do evento é obrigatório'};
      }

      if (event.descricao.trim().isEmpty) {
        return {'success': false, 'error': 'Descrição do evento é obrigatória'};
      }

      if (event.data.isBefore(DateTime.now())) {
        return {'success': false, 'error': 'Data do evento deve ser no futuro'};
      }

      // Create new event with proper ID
      final newEvent = Evento(
        id: const Uuid().v4(),
        creatorId: event.creatorId,
        titulo: event.titulo.trim(),
        descricao: event.descricao.trim(),
        data: event.data,
        local: event.local?.trim(),
        categoria: event.categoria,
        maxParticipantes: event.maxParticipantes,
        createdAt: DateTime.now(),
      );

      await _storageService.saveEvent(newEvent);

      return {'success': true, 'event': newEvent};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> updateEvent(Evento event) async {
    try {
      // Validate event data
      if (event.titulo.trim().isEmpty) {
        return {'success': false, 'error': 'Título do evento é obrigatório'};
      }

      if (event.descricao.trim().isEmpty) {
        return {'success': false, 'error': 'Descrição do evento é obrigatória'};
      }

      if (event.data.isBefore(DateTime.now())) {
        return {'success': false, 'error': 'Data do evento deve ser no futuro'};
      }

      await _storageService.saveEvent(event);

      return {'success': true, 'event': event};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> removeEvent(String eventId) async {
    try {
      await _storageService.deleteEvent(eventId);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> joinEvent(String eventId, String userId) async {
    try {
      // Get event details
      final events = await getAllEvents();
      final event = events.firstWhere(
        (e) => e.id == eventId,
        orElse: () => throw Exception('Evento não encontrado'),
      );

      // Check if user is already a participant
      if (event.participantes.contains(userId)) {
        return {'success': false, 'error': 'Você já está participando deste evento'};
      }

      // Check if event is full
      if (event.maxParticipantes != null && 
          event.participantes.length >= event.maxParticipantes!) {
        return {'success': false, 'error': 'Evento lotado'};
      }

      // Check if event is in the future
      if (event.data.isBefore(DateTime.now())) {
        return {'success': false, 'error': 'Não é possível participar de eventos passados'};
      }

      await _storageService.addEventParticipant(eventId, userId);

      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> leaveEvent(String eventId, String userId) async {
    try {
      // Get event details
      final events = await getAllEvents();
      final event = events.firstWhere(
        (e) => e.id == eventId,
        orElse: () => throw Exception('Evento não encontrado'),
      );

      // Check if user is a participant
      if (!event.participantes.contains(userId)) {
        return {'success': false, 'error': 'Você não está participando deste evento'};
      }

      // Check if event is in the future (allow leaving only future events)
      if (event.data.isBefore(DateTime.now())) {
        return {'success': false, 'error': 'Não é possível sair de eventos passados'};
      }

      await _storageService.removeEventParticipant(eventId, userId);

      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<List<Evento>> searchEvents({
    String? query,
    EventCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
  }) async {
    try {
      var events = await getAllEvents();

      // Filter by search query
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        events = events.where((event) =>
          event.titulo.toLowerCase().contains(lowerQuery) ||
          event.descricao.toLowerCase().contains(lowerQuery) ||
          (event.local?.toLowerCase().contains(lowerQuery) ?? false)
        ).toList();
      }

      // Filter by category
      if (category != null) {
        events = events.where((event) => event.categoria == category).toList();
      }

      // Filter by date range
      if (startDate != null) {
        events = events.where((event) => event.data.isAfter(startDate) || 
                                        event.data.isAtSameMomentAs(startDate)).toList();
      }

      if (endDate != null) {
        events = events.where((event) => event.data.isBefore(endDate) || 
                                        event.data.isAtSameMomentAs(endDate)).toList();
      }

      // Filter by location
      if (location != null && location.isNotEmpty) {
        final lowerLocation = location.toLowerCase();
        events = events.where((event) =>
          event.local?.toLowerCase().contains(lowerLocation) ?? false
        ).toList();
      }

      // Sort by date (nearest first)
      events.sort((a, b) => a.data.compareTo(b.data));

      return events;
    } catch (e) {
      throw Exception('Erro na busca: $e');
    }
  }

  Future<List<Evento>> getUpcomingEvents({int limit = 10}) async {
    try {
      final events = await getAllEvents();
      final now = DateTime.now();
      
      // Filter future events only
      final upcomingEvents = events.where((event) => event.data.isAfter(now)).toList();
      
      // Sort by date (nearest first)
      upcomingEvents.sort((a, b) => a.data.compareTo(b.data));
      
      // Limit results
      return upcomingEvents.take(limit).toList();
    } catch (e) {
      throw Exception('Erro ao carregar próximos eventos: $e');
    }
  }

  Future<List<Evento>> getEventsByCategory(EventCategory category) async {
    try {
      final events = await getAllEvents();
      return events.where((event) => event.categoria == category).toList();
    } catch (e) {
      throw Exception('Erro ao carregar eventos por categoria: $e');
    }
  }

  Future<Map<String, dynamic>> getEventStats() async {
    try {
      final events = await getAllEvents();
      final now = DateTime.now();
      
      final totalEvents = events.length;
      final upcomingEvents = events.where((e) => e.data.isAfter(now)).length;
      final pastEvents = events.where((e) => e.data.isBefore(now)).length;
      final totalParticipants = events.fold<int>(0, (sum, event) => sum + event.participantes.length);
      
      return {
        'totalEvents': totalEvents,
        'upcomingEvents': upcomingEvents,
        'pastEvents': pastEvents,
        'totalParticipants': totalParticipants,
        'averageParticipants': totalEvents > 0 ? (totalParticipants / totalEvents).round() : 0,
      };
    } catch (e) {
      throw Exception('Erro ao calcular estatísticas: $e');
    }
  }
}