import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class SkillsService {
  final StorageService _storageService = StorageService();

  Future<List<Habilidade>> getUserSkills(String userId) async {
    try {
      return await _storageService.getUserSkills(userId);
    } catch (e) {
      throw Exception('Erro ao carregar habilidades do usuário: $e');
    }
  }

  Future<List<Habilidade>> getAllSkills() async {
    try {
      return await _storageService.getAllSkills();
    } catch (e) {
      throw Exception('Erro ao carregar todas as habilidades: $e');
    }
  }

  Future<Map<String, dynamic>> addSkill(Habilidade skill, String userId) async {
    try {
      // Validate skill data
      if (skill.nome.trim().isEmpty) {
        return {'success': false, 'error': 'Nome da habilidade é obrigatório'};
      }

      if (skill.descricao.trim().isEmpty) {
        return {
          'success': false,
          'error': 'Descrição da habilidade é obrigatória',
        };
      }

      // Check if user already has this skill
      final userSkills = await getUserSkills(userId);
      final hasSkill = userSkills.any(
        (s) => s.nome.toLowerCase().trim() == skill.nome.toLowerCase().trim(),
      );

      if (hasSkill) {
        return {'success': false, 'error': 'Você já possui esta habilidade'};
      }

      // Create new skill with proper ID and user association
      final newSkill = Habilidade(
        id: const Uuid().v4(),
        userId: userId,
        nome: skill.nome.trim(),
        descricao: skill.descricao.trim(),
        categoria: skill.categoria,
        nivel: skill.nivel,
        createdAt: DateTime.now(),
      );

      await _storageService.saveSkill(newSkill);

      return {'success': true, 'skill': newSkill};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> updateSkill(
    Habilidade skill,
    String userId,
  ) async {
    try {
      // Validate ownership
      final userSkills = await getUserSkills(userId);
      final isOwner = userSkills.any((s) => s.id == skill.id);

      if (!isOwner) {
        return {
          'success': false,
          'error': 'Você não tem permissão para editar esta habilidade',
        };
      }

      // Validate skill data
      if (skill.nome.trim().isEmpty) {
        return {'success': false, 'error': 'Nome da habilidade é obrigatório'};
      }

      if (skill.descricao.trim().isEmpty) {
        return {
          'success': false,
          'error': 'Descrição da habilidade é obrigatória',
        };
      }

      // Update skill
      await _storageService.saveSkill(skill);

      return {'success': true, 'skill': skill};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> removeSkill(
    String skillId,
    String userId,
  ) async {
    try {
      // Validate ownership
      final userSkills = await getUserSkills(userId);
      final isOwner = userSkills.any((s) => s.id == skillId);

      if (!isOwner) {
        return {
          'success': false,
          'error': 'Você não tem permissão para remover esta habilidade',
        };
      }

      await _storageService.deleteSkill(skillId);

      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<List<SkillMatch>> findSkillMatches(String userId) async {
    try {
      final userSkills = await getUserSkills(userId);
      final allSkills = await getAllSkills();
      final matches = <SkillMatch>[];

      // Simple matching algorithm
      for (final userSkill in userSkills) {
        // Find skills from other users in the same category
        final potentialMatches = allSkills
            .where(
              (skill) =>
                  skill.userId != userId && // Not the same user
                  skill.categoria == userSkill.categoria && // Same category
                  skill.nome.toLowerCase() !=
                      userSkill.nome.toLowerCase(), // Different skill
            )
            .toList();

        for (final match in potentialMatches) {
          // Create skill match
          final skillMatch = SkillMatch(
            id: const Uuid().v4(),
            user1Id: userId,
            user2Id: match.userId,
            skill1Id: userSkill.id,
            skill2Id: match.id,
            status: MatchStatus.pending,
            createdAt: DateTime.now(),
          );

          matches.add(skillMatch);
        }
      }

      // Sort by creation date (newest first) and limit results
      matches.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return matches.take(20).toList();
    } catch (e) {
      throw Exception('Erro ao buscar correspondências: $e');
    }
  }

  Future<List<Habilidade>> searchSkills({
    String? query,
    SkillCategory? category,
    SkillLevel? level,
    String? excludeUserId,
  }) async {
    try {
      var skills = await getAllSkills();

      // Filter by user (exclude specific user)
      if (excludeUserId != null) {
        skills = skills
            .where((skill) => skill.userId != excludeUserId)
            .toList();
      }

      // Filter by search query
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        skills = skills
            .where(
              (skill) =>
                  skill.nome.toLowerCase().contains(lowerQuery) ||
                  skill.descricao.toLowerCase().contains(lowerQuery),
            )
            .toList();
      }

      // Filter by category
      if (category != null) {
        skills = skills.where((skill) => skill.categoria == category).toList();
      }

      // Filter by level
      if (level != null) {
        skills = skills.where((skill) => skill.nivel == level).toList();
      }

      // Sort by creation date (newest first)
      skills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return skills;
    } catch (e) {
      throw Exception('Erro na busca: $e');
    }
  }

  Future<Map<String, dynamic>> requestSkillExchange(
    String fromUserId,
    String toUserId,
    String fromSkillId,
    String toSkillId,
  ) async {
    try {
      // Validate that both skills exist and belong to the correct users
      final fromUserSkills = await getUserSkills(fromUserId);
      final toUserSkills = await getUserSkills(toUserId);

      fromUserSkills.firstWhere(
        (s) => s.id == fromSkillId,
        orElse: () => throw Exception('Habilidade não encontrada'),
      );

      toUserSkills.firstWhere(
        (s) => s.id == toSkillId,
        orElse: () =>
            throw Exception('Habilidade do outro usuário não encontrada'),
      );

      // Create skill match request
      final skillMatch = SkillMatch(
        id: const Uuid().v4(),
        user1Id: fromUserId,
        user2Id: toUserId,
        skill1Id: fromSkillId,
        skill2Id: toSkillId,
        status: MatchStatus.pending,
        createdAt: DateTime.now(),
      );

      // Save to database (would need to implement this in storage service)
      // await _storageService.saveSkillMatch(skillMatch);

      return {'success': true, 'match': skillMatch};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }
}
