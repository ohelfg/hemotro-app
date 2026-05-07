import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  AuthProvider({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // Initialize auth state
  Future<void> initializeAuth() async {
    final token = _storageService.getAuthToken();
    if (token != null) {
      _apiService.setAuthToken(token);
      try {
        await fetchCurrentUser();
      } catch (e) {
        await logout();
      }
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      final token = result['token'] ?? result['sessionToken'];
      
      if (token != null) {
        _apiService.setAuthToken(token);
        await _storageService.saveAuthToken(token);
        await fetchCurrentUser();
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('No token received');
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.register(email, password, name);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch current user
  Future<void> fetchCurrentUser() async {
    try {
      _currentUser = await _apiService.getCurrentUser();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.logout();
      _currentUser = null;
      _isAuthenticated = false;
      _error = null;
      await _storageService.clearAuthToken();
      await _storageService.clearUserData();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
