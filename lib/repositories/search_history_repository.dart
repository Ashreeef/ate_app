import 'package:shared_preferences/shared_preferences.dart';

/// Repository for Search History data operations - Local Storage Version
class SearchHistoryRepository {
  static const String _kHistoryKeyPrefix = 'search_history_';

  // ==================== CREATE ====================

  /// Add a search query to history
  Future<void> addSearchQuery(String userUid, String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_kHistoryKeyPrefix$userUid';
      
      // Get existing history
      List<String> history = prefs.getStringList(key) ?? [];
      
      // Remove if already exists (to move it to top)
      history.remove(query);
      
      // Add to top
      history.insert(0, query);
      
      // Limit history size to 50 items
      if (history.length > 50) {
        history = history.sublist(0, 50);
      }
      
      await prefs.setStringList(key, history);
    } catch (e) {
      print('Error adding search query locally: $e');
    }
  }

  // ==================== READ ====================

  /// Get unique recent search queries
  Future<List<String>> getUniqueRecentSearchQueries(
    String userUid, {
    int limit = 10,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_kHistoryKeyPrefix$userUid';
      
      final history = prefs.getStringList(key) ?? [];
      
      return history.take(limit).toList();
    } catch (e) {
      print('Error getting search history locally: $e');
      return [];
    }
  }

  // ==================== DELETE ====================

  /// Delete a specific query from history
  Future<void> deleteSearchQuery(String userUid, String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_kHistoryKeyPrefix$userUid';
      
      List<String> history = prefs.getStringList(key) ?? [];
      
      if (history.contains(query)) {
        history.remove(query);
        await prefs.setStringList(key, history);
      }
    } catch (e) {
      print('Error deleting search query locally: $e');
    }
  }

  /// Clear all search history for a user
  Future<void> clearSearchHistoryByUserUid(String userUid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_kHistoryKeyPrefix$userUid';
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing search history locally: $e');
    }
  }
}
