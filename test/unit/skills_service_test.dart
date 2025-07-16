import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/services/skills_service.dart';
import 'package:lacos/models/models.dart';

void main() {
  group('SkillsService Tests', () {
    late SkillsService skillsService;
    const testUserId = 'test-user-id';
    const otherUserId = 'other-user-id';

    setUp(() {
      skillsService = SkillsService();
    });

    group('Add Skill', () {
      test('should successfully add a new skill', () async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: 'Flutter Development',
          descricao: 'Mobile app development with Flutter',
          categoria: SkillCategory.tecnologia,
          nivel: SkillLevel.intermediario,
        );

        final result = await skillsService.addSkill(skill, testUserId);

        expect(result['success'], true);
        expect(result['skill'], isA<Habilidade>());
        expect(result['skill'].nome, 'Flutter Development');
        expect(result['skill'].userId, testUserId);
        expect(result['skill'].id, isNotEmpty);
      });

      test('should fail to add skill with empty name', () async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: '',
          descricao: 'Valid description',
        );

        final result = await skillsService.addSkill(skill, testUserId);

        expect(result['success'], false);
        expect(result['error'], 'Nome da habilidade é obrigatório');
      });

      test('should fail to add skill with empty description', () async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: 'Valid Name',
          descricao: '',
        );

        final result = await skillsService.addSkill(skill, testUserId);

        expect(result['success'], false);
        expect(result['error'], 'Descrição da habilidade é obrigatória');
      });

      test('should fail to add duplicate skill for same user', () async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: 'Flutter Development',
          descricao: 'Mobile app development',
        );

        // Add skill first time
        await skillsService.addSkill(skill, testUserId);

        // Try to add same skill again
        final result = await skillsService.addSkill(skill, testUserId);

        expect(result['success'], false);
        expect(result['error'], 'Você já possui esta habilidade');
      });

      test('should trim whitespace from skill name and description', () async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: '  Flutter Development  ',
          descricao: '  Mobile app development  ',
        );

        final result = await skillsService.addSkill(skill, testUserId);

        expect(result['success'], true);
        expect(result['skill'].nome, 'Flutter Development');
        expect(result['skill'].descricao, 'Mobile app development');
      });
    });

    group('Update Skill', () {
      late Habilidade existingSkill;

      setUp(() async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: 'Original Name',
          descricao: 'Original description',
        );

        final result = await skillsService.addSkill(skill, testUserId);
        existingSkill = result['skill'];
      });

      test('should successfully update existing skill', () async {
        final updatedSkill = Habilidade(
          id: existingSkill.id,
          userId: testUserId,
          nome: 'Updated Name',
          descricao: 'Updated description',
          categoria: SkillCategory.artes,
          nivel: SkillLevel.avancado,
        );

        final result = await skillsService.updateSkill(updatedSkill, testUserId);

        expect(result['success'], true);
        expect(result['skill'].nome, 'Updated Name');
        expect(result['skill'].descricao, 'Updated description');
      });

      test('should fail to update skill not owned by user', () async {
        final updatedSkill = Habilidade(
          id: existingSkill.id,
          userId: testUserId,
          nome: 'Updated Name',
          descricao: 'Updated description',
        );

        final result = await skillsService.updateSkill(updatedSkill, otherUserId);

        expect(result['success'], false);
        expect(result['error'], 'Você não tem permissão para editar esta habilidade');
      });

      test('should fail to update skill with empty name', () async {
        final updatedSkill = Habilidade(
          id: existingSkill.id,
          userId: testUserId,
          nome: '',
          descricao: 'Valid description',
        );

        final result = await skillsService.updateSkill(updatedSkill, testUserId);

        expect(result['success'], false);
        expect(result['error'], 'Nome da habilidade é obrigatório');
      });
    });

    group('Remove Skill', () {
      late Habilidade existingSkill;

      setUp(() async {
        final skill = Habilidade(
          id: '',
          userId: testUserId,
          nome: 'Skill to Remove',
          descricao: 'This skill will be removed',
        );

        final result = await skillsService.addSkill(skill, testUserId);
        existingSkill = result['skill'];
      });

      test('should successfully remove existing skill', () async {
        final result = await skillsService.removeSkill(existingSkill.id, testUserId);

        expect(result['success'], true);
      });

      test('should fail to remove skill not owned by user', () async {
        final result = await skillsService.removeSkill(existingSkill.id, otherUserId);

        expect(result['success'], false);
        expect(result['error'], 'Você não tem permissão para remover esta habilidade');
      });
    });

    group('Search Skills', () {
      setUp(() async {
        // Add some test skills
        final skills = [
          Habilidade(
            id: '',
            userId: testUserId,
            nome: 'Flutter Development',
            descricao: 'Mobile app development with Flutter framework',
            categoria: SkillCategory.tecnologia,
            nivel: SkillLevel.intermediario,
          ),
          Habilidade(
            id: '',
            userId: otherUserId,
            nome: 'React Development',
            descricao: 'Web development with React library',
            categoria: SkillCategory.tecnologia,
            nivel: SkillLevel.avancado,
          ),
          Habilidade(
            id: '',
            userId: otherUserId,
            nome: 'Guitar Playing',
            descricao: 'Acoustic and electric guitar',
            categoria: SkillCategory.musica,
            nivel: SkillLevel.iniciante,
          ),
        ];

        for (final skill in skills) {
          await skillsService.addSkill(skill, skill.userId);
        }
      });

      test('should search skills by name', () async {
        final results = await skillsService.searchSkills(query: 'Flutter');

        expect(results.length, 1);
        expect(results.first.nome, 'Flutter Development');
      });

      test('should search skills by description', () async {
        final results = await skillsService.searchSkills(query: 'guitar');

        expect(results.length, 1);
        expect(results.first.nome, 'Guitar Playing');
      });

      test('should filter skills by category', () async {
        final results = await skillsService.searchSkills(
          category: SkillCategory.tecnologia,
        );

        expect(results.length, 2);
        expect(results.every((skill) => skill.categoria == SkillCategory.tecnologia), true);
      });

      test('should filter skills by level', () async {
        final results = await skillsService.searchSkills(
          level: SkillLevel.avancado,
        );

        expect(results.length, 1);
        expect(results.first.nivel, SkillLevel.avancado);
      });

      test('should exclude specific user from results', () async {
        final results = await skillsService.searchSkills(
          excludeUserId: testUserId,
        );

        expect(results.every((skill) => skill.userId != testUserId), true);
      });

      test('should combine multiple search criteria', () async {
        final results = await skillsService.searchSkills(
          query: 'development',
          category: SkillCategory.tecnologia,
          excludeUserId: testUserId,
        );

        expect(results.length, 1);
        expect(results.first.nome, 'React Development');
      });

      test('should return empty list for no matches', () async {
        final results = await skillsService.searchSkills(query: 'nonexistent');

        expect(results.isEmpty, true);
      });
    });

    group('Skill Matching', () {
      setUp(() async {
        // Add skills for matching
        final user1Skills = [
          Habilidade(
            id: '',
            userId: testUserId,
            nome: 'Flutter Development',
            descricao: 'Mobile development',
            categoria: SkillCategory.tecnologia,
          ),
          Habilidade(
            id: '',
            userId: testUserId,
            nome: 'Guitar Playing',
            descricao: 'Music skill',
            categoria: SkillCategory.musica,
          ),
        ];

        final user2Skills = [
          Habilidade(
            id: '',
            userId: otherUserId,
            nome: 'React Development',
            descricao: 'Web development',
            categoria: SkillCategory.tecnologia,
          ),
          Habilidade(
            id: '',
            userId: otherUserId,
            nome: 'Piano Playing',
            descricao: 'Music skill',
            categoria: SkillCategory.musica,
          ),
        ];

        for (final skill in [...user1Skills, ...user2Skills]) {
          await skillsService.addSkill(skill, skill.userId);
        }
      });

      test('should find skill matches based on categories', () async {
        final matches = await skillsService.findSkillMatches(testUserId);

        expect(matches.isNotEmpty, true);
        expect(matches.every((match) => match.user1Id == testUserId), true);
        expect(matches.every((match) => match.user2Id != testUserId), true);
      });

      test('should not match user with themselves', () async {
        final matches = await skillsService.findSkillMatches(testUserId);

        expect(matches.every((match) => match.user1Id != match.user2Id), true);
      });

      test('should limit number of matches returned', () async {
        final matches = await skillsService.findSkillMatches(testUserId);

        expect(matches.length, lessThanOrEqualTo(20));
      });
    });
  });
}