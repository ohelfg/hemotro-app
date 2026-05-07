import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class StorageService {
  late SharedPreferences _prefs;
  final Logger _logger = Logger();

  static const String _authTokenKey = 'auth_token';
  static const String _userKey = 'user';
  static const String _favoriteSeriesKey = 'favorite_series';
  static const String _watchHistoryKey = 'watch_history';
  static const String _preferredQualityKey = 'preferred_quality';

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('Storage initialized');
    } catch (e) {
      _logger.e('Error initializing storage: $e');
      rethrow;
    }
  }

  // Auth token methods
  Future<void> saveAuthToken(String token) async {
    try {
      await _prefs.setString(_authTokenKey, token);
      _logger.i('Auth token saved');
    } catch (e) {
      _logger.e('Error saving auth token: $e');
      rethrow;
    }
  }

  String? getAuthToken() {
    try {
      return _prefs.getString(_authTokenKey);
    } catch (e) {
      _logger.e('Error getting auth token: $e');
      return null;
    }
  }

  Future<void> clearAuthToken() async {
    try {
      await _prefs.remove(_authTokenKey);
      _logger.i('Auth token cleared');
    } catch (e) {
      _logger.e('Error clearing auth token: $e');
      rethrow;
    }
  }

  // User data methods
  Future<void> saveUserData(String userData) async {
    try {
      await _prefs.setString(_userKey, userData);
      _logger.i('User data saved');
    } catch (e) {
      _logger.e('Error saving user data: $e');
      rethrow;
    }
  }

  String? getUserData() {
    try {
      return _prefs.getString(_userKey);
    } catch (e) {
      _logger.e('Error getting user data: $e');
      return null;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _prefs.remove(_userKey);
      _logger.i('User data cleared');
    } catch (e) {
      _logger.e('Error clearing user data: $e');
      rethrow;
    }
  }

  // Favorite series methods
  Future<void> addFavoriteSeries(String seriesId) async {
    try {
      final favorites = _prefs.getStringList(_favoriteSeriesKey) ?? [];
      if (!favorites.contains(seriesId)) {
        favorites.add(seriesId);
        await _prefs.setStringList(_favoriteSeriesKey, favorites);
        _logger.i('Series added to favorites');
      }
    } catch (e) {
      _logger.e('Error adding favorite series: $e');
      rethrow;
    }
  }

  Future<void> removeFavoriteSeries(String seriesId) async {
    try {
      final favorites = _prefs.getStringList(_favoriteSeriesKey) ?? [];
      favorites.remove(seriesId);
      await _prefs.setStringList(_favoriteSeriesKey, favorites);
      _logger.i('Series removed from favorites');
    } catch (e) {
      _logger.e('Error removing favorite series: $e');
      rethrow;
    }
  }

  List<String> getFavoriteSeries() {
    try {
      return _prefs.getStringList(_favoriteSeriesKey) ?? [];
    } catch (e) {
      _logger.e('Error getting favorite series: $e');
      return [];
    }
  }

  bool isFavoriteSeries(String seriesId) {
    return getFavoriteSeries().contains(seriesId);
  }

  // Watch history methods
  Future<void> addToWatchHistory(String episodeId) async {
    try {
      final history = _prefs.getStringList(_watchHistoryKey) ?? [];
      history.remove(episodeId);
      history.insert(0, episodeId);
      if (history.length > 100) {
        history.removeLast();
      }
      await _prefs.setStringList(_watchHistoryKey, history);
      _logger.i('Episode added to watch history');
    } catch (e) {
      _logger.e('Error adding to watch history: $e');
      rethrow;
    }
  }

  List<String> getWatchHistory() {
    try {
      return _prefs.getStringList(_watchHistoryKey) ?? [];
    } catch (e) {
      _logger.e('Error getting watch history: $e');
      return [];
    }
  }

  // Preferred quality methods
  Future<void> setPreferredQuality(String quality) async {
    try {
      await _prefs.setString(_preferredQualityKey, quality);
      _logger.i('Preferred quality set to: $quality');
    } catch (e) {
      _logger.e('Error setting preferred quality: $e');
      rethrow;
    }
  }

  String getPreferredQuality() {
    try {
      return _prefs.getString(_preferredQualityKey) ?? '720p';
    } catch (e) {
      _logger.e('Error getting preferred quality: $e');
      return '720p';
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    try {
      await _prefs.clear();
      _logger.i('All storage cleared');
    } catch (e) {
      _logger.e('Error clearing all storage: $e');
      rethrow;
    }
  }
}
