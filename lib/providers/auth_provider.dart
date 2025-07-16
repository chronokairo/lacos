import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  
  Usuario? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  Usuario? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // Initialize auth state
  Future<void> initializeAuth() async {
    _setLoading(true);
    try {
      final token = await _storageService.getToken();
      if (token != null && !_authService.isTokenExpired(token)) {
        final user = await _storageService.getCurrentUser();
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
        }
      } else {
        await logout();
      }
    } catch (e) {
      _setError('Erro ao inicializar autenticação: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.login(email, password);
      if (result['success']) {
        _currentUser = result['user'];
        _isAuthenticated = true;
        
        // Save to local storage
        await _storageService.saveToken(result['token']);
        await _storageService.saveCurrentUser(_currentUser!);
        
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro no login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.register(name, email, password);
      if (result['success']) {
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro no cadastro: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _storageService.clearAll();
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _setError('Erro no logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(Usuario updatedUser) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.updateProfile(updatedUser);
      if (result['success']) {
        _currentUser = result['user'];
        await _storageService.saveCurrentUser(_currentUser!);
        notifyListeners();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Erro ao atualizar perfil: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}