import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/providers/agent_provider.dart';
import 'package:lacos/services/local_data_service.dart';
import 'package:lacos/models/models.dart';

void main() {
  group('AgentProvider Tests', () {
    late AgentProvider agentProvider;
    late LocalDataService dataService;

    setUp(() {
      agentProvider = AgentProvider();
      dataService = LocalDataService();
      
      // Limpar dados existentes
      dataService.usuarios.clear();
      
      // Adicionar usuário de teste
      final usuario = Usuario(
        id: '1',
        nome: 'Usuário Teste',
        email: 'teste@email.com',
        senha: 'senhahasheada',
        habilidades: [
          Habilidade(
            id: '1',
            userId: '1',
            nome: 'Programação',
            descricao: 'Flutter e Dart',
          ),
        ],
      );
      dataService.usuarios.add(usuario);
    });

    tearDown(() {
      dataService.usuarios.clear();
    });

    test('deve inicializar com estado vazio', () {
      // Assert
      expect(agentProvider.matches, isEmpty);
      expect(agentProvider.recomendacoes, isEmpty);
      expect(agentProvider.dicas, isEmpty);
      expect(agentProvider.isLoading, isFalse);
      expect(agentProvider.error, isNull);
    });

    test('deve carregar dados do agente corretamente', () async {
      // Act
      await agentProvider.carregarDadosAgente('1');

      // Assert
      expect(agentProvider.isLoading, isFalse);
      expect(agentProvider.error, isNull);
      expect(agentProvider.dicas, isNotEmpty);
    });

    test('deve definir isLoading durante carregamento', () async {
      // Act
      final future = agentProvider.carregarDadosAgente('1');
      
      // Assert durante o carregamento
      expect(agentProvider.isLoading, isTrue);
      expect(agentProvider.error, isNull);
      
      // Aguarda conclusão
      await future;
      
      // Assert após carregamento
      expect(agentProvider.isLoading, isFalse);
    });

    test('deve limpar dados corretamente', () async {
      // Arrange
      await agentProvider.carregarDadosAgente('1');
      expect(agentProvider.dicas, isNotEmpty);

      // Act
      agentProvider.limparDados();

      // Assert
      expect(agentProvider.matches, isEmpty);
      expect(agentProvider.recomendacoes, isEmpty);
      expect(agentProvider.dicas, isEmpty);
      expect(agentProvider.error, isNull);
    });

    test('deve atualizar recomendações', () {
      // Act
      agentProvider.atualizarRecomendacoes('1');

      // Assert
      expect(agentProvider.error, isNull);
      expect(agentProvider.dicas, isNotEmpty);
    });
  });
}