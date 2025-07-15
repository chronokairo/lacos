import '../models/models.dart';

/// Serviço local para simular persistência de dados em memória.
class LocalDataService {
  static final LocalDataService _instance = LocalDataService._internal();
  factory LocalDataService() => _instance;
  LocalDataService._internal();

  final List<Usuario> _usuarios = [];
  final List<Evento> _eventos = [];
  Usuario? _usuarioLogado;

  // Usuário
  List<Usuario> get usuarios => _usuarios;
  Usuario? get usuarioLogado => _usuarioLogado;

  bool autenticar(String email, String senha) {
    final user = _usuarios.firstWhere(
      (u) => u.email == email && u.senha == senha,
      orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
    );
    if (user.id.isNotEmpty) {
      _usuarioLogado = user;
      return true;
    }
    return false;
  }

  void logout() {
    _usuarioLogado = null;
  }

  void cadastrarUsuario(Usuario usuario) {
    _usuarios.add(usuario);
  }

  // Evento
  List<Evento> get eventos => _eventos;
  void adicionarEvento(Evento evento) {
    _eventos.add(evento);
  }

  void removerEvento(String id) {
    _eventos.removeWhere((e) => e.id == id);
  }

  // Habilidades
  void adicionarHabilidadeAoUsuario(String userId, Habilidade habilidade) {
    final user = _usuarios.firstWhere(
      (u) => u.id == userId,
      orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
    );
    if (user.id.isNotEmpty) {
      user.habilidades = [...user.habilidades, habilidade];
    }
  }
}
