import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:crypto/crypto.dart';

final _usuariosDir = Directory('usuario');
final _usuariosFile = File('usuario/usuarios.json');

Future<List<Map<String, dynamic>>> carregarUsuarios() async {
  if (!await _usuariosDir.exists()) await _usuariosDir.create();
  if (!await _usuariosFile.exists()) await _usuariosFile.writeAsString('[]');
  final data = await _usuariosFile.readAsString();
  return List<Map<String, dynamic>>.from(jsonDecode(data));
}

Future<void> salvarUsuarios(List<Map<String, dynamic>> usuarios) async {
  await _usuariosFile.writeAsString(jsonEncode(usuarios));
}

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

void main() async {
  final router = Router();

  // Registro
  router.post('/register', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    if (email == null || password == null) {
      return Response(400, body: jsonEncode({'error': 'Dados inválidos'}));
    }
    final users = await carregarUsuarios();
    if (users.any((u) => u['email'] == email)) {
      return Response(400, body: jsonEncode({'error': 'Usuário já existe'}));
    }
    final hash = hashPassword(password);
    users.add({'email': email, 'password': hash});
    await salvarUsuarios(users);
    return Response(
      201,
      body: jsonEncode({'message': 'Usuário registrado com sucesso'}),
    );
  });

  // Login
  router.post('/login', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    if (email == null || password == null) {
      return Response(400, body: jsonEncode({'error': 'Dados inválidos'}));
    }
    final users = await carregarUsuarios();
    final user = users.firstWhere((u) => u['email'] == email, orElse: () => {});
    if (user.isEmpty) {
      return Response(
        400,
        body: jsonEncode({'error': 'Usuário não encontrado'}),
      );
    }
    final hash = hashPassword(password);
    if (user['password'] != hash) {
      return Response(401, body: jsonEncode({'error': 'Senha incorreta'}));
    }
    // Sessão simples via cookie (não seguro para produção)
    final headers = {
      'Set-Cookie': 'user=${Uri.encodeComponent(email)}; HttpOnly; Path=/',
      'Content-Type': 'application/json',
    };
    return Response.ok(
      jsonEncode({'message': 'Login realizado com sucesso'}),
      headers: headers,
    );
  });

  // Logout
  router.post('/logout', (Request request) async {
    final headers = {
      'Set-Cookie': 'user=; Max-Age=0; Path=/',
      'Content-Type': 'application/json',
    };
    return Response.ok(
      jsonEncode({'message': 'Logout realizado com sucesso'}),
      headers: headers,
    );
  });

  // Profile (protegido)
  router.get('/profile', (Request request) async {
    final cookies = request.headers['cookie'] ?? '';
    final userCookie = RegExp(r'user=([^;]+)').firstMatch(cookies);
    if (userCookie == null) {
      return Response(401, body: jsonEncode({'error': 'Não autenticado'}));
    }
    final email = Uri.decodeComponent(userCookie.group(1)!);
    return Response.ok(
      jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Página inicial
  router.get('/', (Request request) async {
    final file = File('index.html');
    if (await file.exists()) {
      return Response.ok(
        await file.readAsString(),
        headers: {'Content-Type': 'text/html'},
      );
    }
    return Response.notFound('index.html não encontrado');
  });

  const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
}
