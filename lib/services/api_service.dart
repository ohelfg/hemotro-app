import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/index.dart';

class ApiService {
  late Dio _dio;
  final Logger _logger = Logger();
  
  // استبدل هذا برابط الخادم الفعلي
  static const String baseUrl = 'https://hemotroapp-mbryaghx.manus.space/api/trpc';
  
  String? _authToken;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          _logger.i('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  // Series endpoints
  Future<List<Series>> getSeries() async {
    try {
      final response = await _dio.get('/series.list');
      final data = response.data['result']['data'] as List;
      return data.map((e) => Series.fromJson(e)).toList();
    } catch (e) {
      _logger.e('Error getting series: $e');
      rethrow;
    }
  }

  Future<Series> getSeriesById(String id) async {
    try {
      final response = await _dio.get('/series.getById', queryParameters: {'id': id});
      return Series.fromJson(response.data['result']['data']);
    } catch (e) {
      _logger.e('Error getting series by id: $e');
      rethrow;
    }
  }

  // Episode endpoints
  Future<List<Episode>> getEpisodesBySeriesId(String seriesId) async {
    try {
      final response = await _dio.get(
        '/episodes.getBySeriesId',
        queryParameters: {'seriesId': seriesId},
      );
      final data = response.data['result']['data'] as List;
      return data.map((e) => Episode.fromJson(e)).toList();
    } catch (e) {
      _logger.e('Error getting episodes: $e');
      rethrow;
    }
  }

  Future<Episode> getEpisodeById(String id) async {
    try {
      final response = await _dio.get('/episodes.getById', queryParameters: {'id': id});
      return Episode.fromJson(response.data['result']['data']);
    } catch (e) {
      _logger.e('Error getting episode by id: $e');
      rethrow;
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth.loginEmail',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data['result']['data'];
    } catch (e) {
      _logger.e('Error logging in: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '/auth.register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      return response.data['result']['data'];
    } catch (e) {
      _logger.e('Error registering: $e');
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth.me');
      return User.fromJson(response.data['result']['data']);
    } catch (e) {
      _logger.e('Error getting current user: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth.logout');
      clearAuthToken();
    } catch (e) {
      _logger.e('Error logging out: $e');
      rethrow;
    }
  }

  // Search endpoint
  Future<List<Series>> searchSeries(String query) async {
    try {
      final response = await _dio.get(
        '/series.search',
        queryParameters: {'query': query},
      );
      final data = response.data['result']['data'] as List;
      return data.map((e) => Series.fromJson(e)).toList();
    } catch (e) {
      _logger.e('Error searching series: $e');
      rethrow;
    }
  }
}
