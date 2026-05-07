import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class SeriesProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Series> _seriesList = [];
  List<Series> _searchResults = [];
  Series? _selectedSeries;
  bool _isLoading = false;
  String? _error;

  SeriesProvider({required ApiService apiService}) : _apiService = apiService;

  // Getters
  List<Series> get seriesList => _seriesList;
  List<Series> get searchResults => _searchResults;
  Series? get selectedSeries => _selectedSeries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all series
  Future<void> fetchSeries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _seriesList = await _apiService.getSeries();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get series by ID
  Future<void> getSeriesById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedSeries = await _apiService.getSeriesById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search series
  Future<void> searchSeries(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchSeries(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
