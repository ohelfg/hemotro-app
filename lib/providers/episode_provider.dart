import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class EpisodeProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  List<Episode> _episodes = [];
  Episode? _currentEpisode;
  bool _isLoading = false;
  String? _error;
  String _preferredQuality = '720p';
  List<String> _watchHistory = [];

  EpisodeProvider({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService {
    _preferredQuality = _storageService.getPreferredQuality();
    _watchHistory = _storageService.getWatchHistory();
  }

  // Getters
  List<Episode> get episodes => _episodes;
  Episode? get currentEpisode => _currentEpisode;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get preferredQuality => _preferredQuality;
  List<String> get watchHistory => _watchHistory;

  // Fetch episodes by series ID
  Future<void> fetchEpisodesBySeriesId(String seriesId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _episodes = await _apiService.getEpisodesBySeriesId(seriesId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get episode by ID
  Future<void> getEpisodeById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentEpisode = await _apiService.getEpisodeById(id);
      await addToWatchHistory(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set preferred quality
  Future<void> setPreferredQuality(String quality) async {
    _preferredQuality = quality;
    await _storageService.setPreferredQuality(quality);
    notifyListeners();
  }

  // Add to watch history
  Future<void> addToWatchHistory(String episodeId) async {
    await _storageService.addToWatchHistory(episodeId);
    _watchHistory = _storageService.getWatchHistory();
    notifyListeners();
  }

  // Get video URL for current quality
  String? getVideoUrlForCurrentQuality() {
    return _currentEpisode?.getVideoUrlForQuality(_preferredQuality);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
