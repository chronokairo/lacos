import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/services/agent_service.dart';
import 'package:lacos/services/local_data_service.dart';
import 'package:lacos/models/models.dart';

void main() {
  group('AgentService Tests', () {
    late AgentService agentService;
    late LocalDataService dataService;

    setUp(() {
      agentService = AgentService();
      dataService = LocalDataService();
      
      // Limpar dados existentes
      dataService.usuarios.clear();
      
      // Adicionar usuários de teste
      final usuario1 = Usuario(
        id: '1',
        nome: 'João Silva',
        email: 'joao@test.com',
        senha: 'hashedpassword1',
        habilidades: [
          Habilidade(
            id: '1',
            userId: '1',
            nome: 'Programação',
            descricao: 'Desenvolvimento em Flutter',
          ),
          Habilidade(
            id: '2',
            userId: '1',
            nome: 'Design',
            descricao: 'UI/UX Design',
          ),
        ],
      );

      final usuario2 = Usuario(
        id: '2',
        nome: 'Maria Santos',
        email: 'maria@test.com',
        senha: 'hashedpassword2',
        habilidades: [
          Habilidade(
            id: '3',
            userId: '2',
            nome: 'Marketing',
            descricao: 'Marketing Digital',
          ),
          Habilidade(
            id: '4',
            userId: '2',
            nome: 'Inglês',
            descricao: 'Inglês fluente',
          ),
        ],
      );

      final usuario3 = Usuario(
        id: '3',
        nome: 'Pedro Costa',
        email: 'pedro@test.com',
        senha: 'hashedpassword3',
        habilidades: [
          Habilidade(
            id: '5',
            userId: '3',
            nome: 'Culinária',
            descricao: 'Cozinha italiana',
          ),
          Habilidade(
            id: '6',
            userId: '3',
            nome: 'Programação',
            descricao: 'Python e JavaScript',
          ),
        ],
      );

      dataService.usuarios.addAll([usuario1, usuario2, usuario3]);
    });

    tearDown(() {
      dataService.usuarios.clear();
    });

    test('deve encontrar matches para um usuário', () {
      // Act
      final matches = agentService.encontrarMatches('1');

      // Assert
      expect(matches, isNotEmpty);
      expect(matches.length, greaterThan(0));
      
      // Verifica se os matches estão ordenados por compatibilidade
      for (int i = 0; i < matches.length - 1; i++) {
        expect(
          matches[i].compatibilidade,
          greaterThanOrEqualTo(matches[i + 1].compatibilidade),
        );
      }
    });

    test('deve gerar recomendações de habilidades', () {
      // Act
      final recomendacoes = agentService.gerarRecomendacoes('1');

      // Assert
      expect(recomendacoes, isA<List<SkillRecommendation>>());
      
      if (recomendacoes.isNotEmpty) {
        // Verifica se as recomendações estão ordenadas por pontuação
        for (int i = 0; i < recomendacoes.length - 1; i++) {
          expect(
            recomendacoes[i].pontuacao,
            greaterThanOrEqualTo(recomendacoes[i + 1].pontuacao),
          );
        }
        
        // Verifica se cada recomendação tem dados válidos
        for (final rec in recomendacoes) {
          expect(rec.nomeHabilidade, isNotEmpty);
          expect(rec.pontuacao, greaterThan(0.0));
          expect(rec.pontuacao, lessThanOrEqualTo(1.0));
          expect(rec.razao, isNotEmpty);
        }
      }
    });

    test('deve gerar dicas personalizadas', () {
      // Act
      final dicas = agentService.gerarDicasPersonalizadas('1');

      // Assert
      expect(dicas, isA<List<String>>());
      expect(dicas.length, greaterThan(0));
      expect(dicas.length, lessThanOrEqualTo(3));
      
      for (final dica in dicas) {
        expect(dica, isNotEmpty);
      }
    });

    test('deve retornar lista vazia para usuário inexistente', () {
      // Act
      final matches = agentService.encontrarMatches('999');
      final recomendacoes = agentService.gerarRecomendacoes('999');
      final dicas = agentService.gerarDicasPersonalizadas('999');

      // Assert
      expect(matches, isEmpty);
      expect(recomendacoes, isEmpty);
      expect(dicas, isEmpty);
    });

    test('deve gerar dica para adicionar habilidades quando usuário não tem nenhuma', () {
      // Arrange
      final usuarioSemHabilidades = Usuario(
        id: '4',
        nome: 'Ana Lima',
        email: 'ana@test.com',
        senha: 'hashedpassword4',
        habilidades: [],
      );
      dataService.usuarios.add(usuarioSemHabilidades);

      // Act
      final dicas = agentService.gerarDicasPersonalizadas('4');

      // Assert
      expect(dicas, isNotEmpty);
      expect(
        dicas.any((dica) => dica.contains('adicionando suas habilidades')),
        isTrue,
      );
    });

    test('deve calcular compatibilidade corretamente', () {
      // Act
      final matches = agentService.encontrarMatches('1');

      // Assert
      expect(matches, isNotEmpty);
      
      for (final match in matches) {
        expect(match.compatibilidade, greaterThan(0.0));
        expect(match.compatibilidade, lessThanOrEqualTo(1.0));
        expect(match.nomeUsuario, isNotEmpty);
        expect(match.usuarioId, isNotEmpty);
        expect(match.explicacao, isNotEmpty);
      }
    });

    test('deve encontrar habilidades complementares', () {
      // Act
      final matches = agentService.encontrarMatches('1');

      // Assert
      expect(matches, isNotEmpty);
      
      for (final match in matches) {
        expect(match.habilidadesComplementares, isA<List<String>>());
        // Pode estar vazia se não houver habilidades complementares
      }
    });

    test('deve limitar número de matches retornados', () {
      // Arrange - Adicionar mais usuários para testar o limite
      for (int i = 4; i <= 15; i++) {
        final usuario = Usuario(
          id: i.toString(),
          nome: 'Usuário $i',
          email: 'user$i@test.com',
          senha: 'hashedpassword$i',
          habilidades: [
            Habilidade(
              id: (i * 10).toString(),
              userId: i.toString(),
              nome: 'Habilidade $i',
              descricao: 'Descrição da habilidade $i',
            ),
          ],
        );
        dataService.usuarios.add(usuario);
      }

      // Act
      final matches = agentService.encontrarMatches('1');

      // Assert
      expect(matches.length, lessThanOrEqualTo(10));
    });

    test('deve limitar número de recomendações retornadas', () {
      // Act
      final recomendacoes = agentService.gerarRecomendacoes('1');

      // Assert
      expect(recomendacoes.length, lessThanOrEqualTo(5));
    });
  });
}