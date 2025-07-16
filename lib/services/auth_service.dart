import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();
  final List<Usuario> _users = [];
  
  // Simulate JWT token generation
  String _generateToken(Usuario user) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final payload = {
      'userId': user.id,
      'email': user.email,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
    };
    
    final headerEncoded = base64Encode(utf8.encode(jsonEncode(header)));
    final payloadEncoded = base64Encode(utf8.encode(jsonEncode(payload)));
    final signature = _generateSignature('$headerEncoded.$payloadEncoded');
    
    return '$headerEncoded.$payloadEncoded.$signature';
  }

  String _generateSignature(String data) {
    final key = utf8.encode(AppConstants.passwordSalt);
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return base64Encode(digest.bytes);
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      
      final payload = jsonDecode(utf8.decode(base64Decode(parts[1])));
      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      return now > exp;
    } catch (e) {
      return true;
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password + AppConstants.passwordSalt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Load users from storage
      await _loadUsers();
      
      final user = _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => Usuario(id: '', nome: '', email: '', senha: ''),
      );
      
      if (user.id.isEmpty) {
        return {'success': false, 'error': 'Usuário não encontrado'};
      }
      
      if (!_verifyPassword(password, user.senha)) {
        return {'success': false, 'error': 'Senha incorreta'};
      }
      
      final token = _generateToken(user);
      
      return {
        'success': true,
        'user': user,
        'token': token,
      };
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      // Load existing users
      await _loadUsers();
      
      // Validate input
      if (name.trim().length < 2) {
        return {'success': false, 'error': 'Nome deve ter pelo menos 2 caracteres'};
      }
      
      if (!_isValidEmail(email)) {
        return {'success': false, 'error': 'Email inválido'};
      }
      
      if (password.length < AppConstants.minPasswordLength) {
        return {'success': false, 'error': 'Senha deve ter pelo menos ${AppConstants.minPasswordLength} caracteres'};
      }
      
      // Check if email already exists
      if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
        return {'success': false, 'error': 'Email já cadastrado'};
      }
      
      // Create new user
      final user = Usuario(
        id: const Uuid().v4(),
        nome: name.trim(),
        email: email.toLowerCase().trim(),
        senha: _hashPassword(password),
        habilidades: [],
      );
      
      _users.add(user);
      await _saveUsers();
      
      return {'success': true, 'user': user};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<Map<String, dynamic>> updateProfile(Usuario updatedUser) async {
    try {
      await _loadUsers();
      
      final index = _users.indexWhere((u) => u.id == updatedUser.id);
      if (index == -1) {
        return {'success': false, 'error': 'Usuário não encontrado'};
      }
      
      // Validate input
      if (updatedUser.nome.trim().length < 2) {
        return {'success': false, 'error': 'Nome deve ter pelo menos 2 caracteres'};
      }
      
      if (!_isValidEmail(updatedUser.email)) {
        return {'success': false, 'error': 'Email inválido'};
      }
      
      // Check if email is already used by another user
      if (_users.any((u) => u.id != updatedUser.id && u.email.toLowerCase() == updatedUser.email.toLowerCase())) {
        return {'success': false, 'error': 'Email já está em uso'};
      }
      
      _users[index] = updatedUser;
      await _saveUsers();
      
      return {'success': true, 'user': updatedUser};
    } catch (e) {
      return {'success': false, 'error': 'Erro interno: $e'};
    }
  }

  Future<void> _loadUsers() async {
    try {
      final usersData = await _storageService.getUsers();
      _users.clear();
      _users.addAll(usersData);
    } catch (e) {
      // If no users exist, start with empty list
      _users.clear();
    }
  }

  Future<void> _saveUsers() async {
    await _storageService.saveUsers(_users);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}