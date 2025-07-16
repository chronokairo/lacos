/// Representa um usuário do sistema.
class Usuario {
  final String id;
  String nome;
  String email;
  String senha;
  List<Habilidade> habilidades;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.habilidades = const [],
  });
}

/// Representa um evento cadastrado no sistema.
class Evento {
  final String id;
  String titulo;
  String descricao;
  DateTime data;

  Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });
}

/// Representa uma habilidade de um usuário.
class Habilidade {
  final String id;
  String nome;
  String descricao;

  Habilidade({required this.id, required this.nome, required this.descricao});
}
