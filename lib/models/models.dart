/// Representa um usuário do sistema.
class Usuario {
  final String id;
  String nome;
  String email;
  String senha;
  String? fotoUrl;
  String? bio;
  List<Habilidade> habilidades;
  DateTime createdAt;
  DateTime updatedAt;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.fotoUrl,
    this.bio,
    this.habilidades = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'foto_url': fotoUrl,
      'bio': bio,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      fotoUrl: json['foto_url'],
      bio: json['bio'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at'] ?? 0),
    );
  }

  Usuario copyWith({
    String? nome,
    String? email,
    String? fotoUrl,
    String? bio,
    List<Habilidade>? habilidades,
  }) {
    return Usuario(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      bio: bio ?? this.bio,
      habilidades: habilidades ?? this.habilidades,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// Representa um evento cadastrado no sistema.
class Evento {
  final String id;
  final String creatorId;
  String titulo;
  String descricao;
  DateTime data;
  String? local;
  EventCategory? categoria;
  int? maxParticipantes;
  List<String> participantes;
  DateTime createdAt;

  Evento({
    required this.id,
    required this.creatorId,
    required this.titulo,
    required this.descricao,
    required this.data,
    this.local,
    this.categoria,
    this.maxParticipantes,
    this.participantes = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'titulo': titulo,
      'descricao': descricao,
      'data': data.millisecondsSinceEpoch,
      'local': local,
      'categoria': categoria?.toString(),
      'max_participantes': maxParticipantes,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      creatorId: json['creator_id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      data: DateTime.fromMillisecondsSinceEpoch(json['data']),
      local: json['local'],
      categoria: json['categoria'] != null
          ? EventCategory.values.firstWhere(
              (e) => e.toString() == json['categoria'],
            )
          : null,
      maxParticipantes: json['max_participantes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] ?? 0),
    );
  }
}

/// Representa uma habilidade de um usuário.
class Habilidade {
  final String id;
  final String userId;
  String nome;
  String descricao;
  SkillCategory? categoria;
  SkillLevel? nivel;
  DateTime createdAt;

  Habilidade({
    required this.id,
    required this.userId,
    required this.nome,
    required this.descricao,
    this.categoria,
    this.nivel,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria?.toString(),
      'nivel': nivel?.toString(),
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Habilidade.fromJson(Map<String, dynamic> json) {
    return Habilidade(
      id: json['id'],
      userId: json['user_id'],
      nome: json['nome'],
      descricao: json['descricao'],
      categoria: json['categoria'] != null
          ? SkillCategory.values.firstWhere(
              (e) => e.toString() == json['categoria'],
            )
          : null,
      nivel: json['nivel'] != null
          ? SkillLevel.values.firstWhere((e) => e.toString() == json['nivel'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] ?? 0),
    );
  }
}

/// Representa uma correspondência de habilidades entre usuários
class SkillMatch {
  final String id;
  final String user1Id;
  final String user2Id;
  final String skill1Id;
  final String skill2Id;
  final MatchStatus status;
  final DateTime createdAt;

  SkillMatch({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.skill1Id,
    required this.skill2Id,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'skill1_id': skill1Id,
      'skill2_id': skill2Id,
      'status': status.toString(),
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SkillMatch.fromJson(Map<String, dynamic> json) {
    return SkillMatch(
      id: json['id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      skill1Id: json['skill1_id'],
      skill2Id: json['skill2_id'],
      status: MatchStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }
}

/// Representa uma mensagem entre usuários
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime sentAt;
  final DateTime? readAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.type = MessageType.text,
    required this.sentAt,
    this.readAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'type': type.toString(),
      'sent_at': sentAt.millisecondsSinceEpoch,
      'read_at': readAt?.millisecondsSinceEpoch,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      type: MessageType.values.firstWhere((e) => e.toString() == json['type']),
      sentAt: DateTime.fromMillisecondsSinceEpoch(json['sent_at']),
      readAt: json['read_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['read_at'])
          : null,
    );
  }
}

/// Enums
enum SkillCategory {
  tecnologia,
  idiomas,
  artes,
  culinaria,
  bemEstar,
  musica,
  esportes,
  negocios,
  educacao,
  outros,
}

enum SkillLevel { iniciante, intermediario, avancado, especialista }

enum EventCategory { workshop, palestra, networking, pratica, social, outros }

enum MatchStatus { pending, accepted, rejected, completed }

enum MessageType { text, image, file, skillRequest }
