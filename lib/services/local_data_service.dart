import 'dart:convert';
import '../models/models.dart';
import '../constants/app_constants.dart';

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
    try {
      if (email.isEmpty || senha.isEmpty) return false;

      final user = _usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
      );

      if (user.id.isNotEmpty && _verificarSenha(senha, user.senha)) {
        _usuarioLogado = user;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _usuarioLogado = null;
  }

  bool cadastrarUsuario(Usuario usuario) {
    try {
      // Validações
      if (!_validarEmail(usuario.email)) {
        throw Exception('Email inválido');
      }

      if (!_validarSenha(usuario.senha)) {
        throw Exception(
          'Senha deve ter pelo menos ${AppConstants.minPasswordLength} caracteres',
        );
      }

      // Verificar se email já existe
      if (_usuarios.any(
        (u) => u.email.toLowerCase() == usuario.email.toLowerCase(),
      )) {
        throw Exception('Email já cadastrado');
      }

      // Hash da senha antes de salvar
      final usuarioComSenhaHash = Usuario(
        id: usuario.id,
        nome: _sanitizarTexto(usuario.nome),
        email: usuario.email.toLowerCase().trim(),
        senha: _hashSenha(usuario.senha),
        habilidades: usuario.habilidades,
      );

      _usuarios.add(usuarioComSenhaHash);
      return true;
    } catch (e) {
      return false;
    }
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
    try {
      final user = _usuarios.firstWhere(
        (u) => u.id == userId,
        orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
      );
      if (user.id.isNotEmpty) {
        final habilidadeSanitizada = Habilidade(
          id: habilidade.id,
          userId: user.id,
          nome: _sanitizarTexto(habilidade.nome),
          descricao: _sanitizarTexto(habilidade.descricao),
        );
        user.habilidades = [...user.habilidades, habilidadeSanitizada];
      }
    } catch (e) {}
  }

  // Métodos de segurança e validação
  String _hashSenha(String senha) {
    // Implementação simples de hash (em produção usar crypto package)
    final bytes = utf8.encode(senha + AppConstants.passwordSalt);
    final digest = bytes.fold(0, (prev, curr) => prev + curr);
    return digest.toString();
  }

  bool _verificarSenha(String senha, String hash) {
    return _hashSenha(senha) == hash;
  }

  bool _validarEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _validarSenha(String senha) {
    return senha.length >= AppConstants.minPasswordLength;
  }

  String _sanitizarTexto(String texto) {
    // Remove caracteres perigosos e normaliza
    return texto
        .trim()
        .replaceAll(RegExp(r'''[<>"']'''), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
