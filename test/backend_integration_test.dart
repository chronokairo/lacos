import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/services/local_data_service.dart';
import 'package:lacos/models/models.dart';

void main() {
  group('Eventos e Habilidades', () {
    test('Adicionar e remover evento', () {
      final service = LocalDataService();
      final evento = Evento(
        id: '1',
        titulo: 'Evento Teste',
        descricao: 'Descrição',
        data: DateTime.now(),
      );
      service.adicionarEvento(evento);
      expect(service.eventos.length, greaterThan(0));
      service.removerEvento('1');
      expect(service.eventos.where((e) => e.id == '1'), isEmpty);
    });

    test('Adicionar habilidade ao usuário', () {
      final service = LocalDataService();
      final usuario = Usuario(
        id: '2',
        nome: 'User',
        email: 'u@e.com',
        senha: '123',
      );
      service.cadastrarUsuario(usuario);
      final habilidade = Habilidade(
        id: 'h1',
        nome: 'Dart',
        descricao: 'Linguagem',
      );
      service.adicionarHabilidadeAoUsuario('2', habilidade);
      expect(
        service.usuarios.firstWhere((u) => u.id == '2').habilidades.length,
        1,
      );
    });
  });
}
