import '../database/database_helper.dart';
import '../models/search_history.dart';

/// Repository for Search History data operations
class SearchHistoryRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Add a search query to history
  Future<int> addSearchQuery(int userId, String query) async {
    return await _db.insert('search_history', {
      'user_id': userId,
      'query': query,
    });
  }

  /// Add multiple search queries in batch
  Future<void> addSearchQueries(int userId, List<String> queries) async {
    final maps = queries.map((q) => {'user_id': userId, 'query': q}).toList();
    await _db.insertBatch('search_history', maps);
  }

  // ==================== READ ====================

  /// Get search history for a user
  Future<List<SearchHistory>> getSearchHistoryByUserId(
    int userId, {
    int limit = 20,
  }) async {
    final maps = await _db.query(
      'search_history',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((map) => SearchHistory.fromMap(map)).toList();
  }

  /// Get recent search queries (strings only)
  Future<List<String>> getRecentSearchQueries(
    int userId, {
    int limit = 10,
  }) async {
    final maps = await _db.query(
      'search_history',
      columns: ['query'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((map) => map['query'] as String).toList();
  }

  /// Get unique recent search queries (no duplicates)
  Future<List<String>> getUniqueRecentSearchQueries(
    int userId, {
    int limit = 10,
  }) async {
    final maps = await _db.rawQuery(
      '''
      SELECT DISTINCT query FROM search_history 
      WHERE user_id = ? 
      ORDER BY created_at DESC 
      LIMIT ?
    ''',
      [userId, limit],
    );
    return maps.map((map) => map['query'] as String).toList();
  }

  /// Search in history
  Future<List<String>> searchInHistory(int userId, String searchTerm) async {
    final maps = await _db.rawQuery(
      '''
      SELECT DISTINCT query FROM search_history 
      WHERE user_id = ? AND query LIKE ? 
      ORDER BY created_at DESC 
      LIMIT 10
    ''',
      [userId, '%$searchTerm%'],
    );
    return maps.map((map) => map['query'] as String).toList();
  }

  /// Get popular searches across all users
  Future<List<Map<String, dynamic>>> getPopularSearches({
    int limit = 10,
  }) async {
    final maps = await _db.rawQuery(
      '''
      SELECT query, COUNT(*) as count 
      FROM search_history 
      GROUP BY query 
      ORDER BY count DESC 
      LIMIT ?
    ''',
      [limit],
    );
    return maps;
  }

  /// Get search history count for a user
  Future<int> getSearchHistoryCountByUserId(int userId) async {
    return await _db.getCount(
      'search_history',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ==================== UPDATE ====================
  // Search history typically doesn't need update operations

  // ==================== DELETE ====================

  /// Delete a specific search history entry
  Future<int> deleteSearchHistoryEntry(int id) async {
    return await _db.delete('search_history', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete a specific query from history
  Future<int> deleteSearchQuery(int userId, String query) async {
    return await _db.delete(
      'search_history',
      where: 'user_id = ? AND query = ?',
      whereArgs: [userId, query],
    );
  }

  /// Clear all search history for a user
  Future<int> clearSearchHistoryByUserId(int userId) async {
    return await _db.delete(
      'search_history',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Delete old search history entries (older than specified days)
  Future<int> deleteOldSearchHistory(int userId, int daysOld) async {
    final cutoffDate = DateTime.now()
        .subtract(Duration(days: daysOld))
        .toIso8601String();
    return await _db.rawDelete(
      '''
      DELETE FROM search_history 
      WHERE user_id = ? AND created_at < ?
    ''',
      [userId, cutoffDate],
    );
  }

  // ==================== UTILITY ====================

  /// Check if a query exists in history
  Future<bool> queryExistsInHistory(int userId, String query) async {
    return await _db.exists(
      'search_history',
      where: 'user_id = ? AND query = ?',
      whereArgs: [userId, query],
    );
  }

  /// Get total search history count
  Future<int> getTotalSearchHistoryCount() async {
    return await _db.getCount('search_history');
  }
}
