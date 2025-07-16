import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/services/local_data_service.dart';
import 'package:lacos/models/models.dart';

void main() {
  group('Cadastro de Usuário', () {
    test('Usuário é cadastrado e pode ser autenticado', () {
      final service = LocalDataService();
      final usuario = Usuario(
        id: '1',
        nome: 'Teste',
        email: 'teste@exemplo.com',
        senha: '1234',
      );
      service.cadastrarUsuario(usuario);
      final autenticado = service.autenticar('teste@exemplo.com', '1234');
      expect(autenticado, isTrue);
      expect(service.usuarioLogado?.email, 'teste@exemplo.com');
    });
  });
}
