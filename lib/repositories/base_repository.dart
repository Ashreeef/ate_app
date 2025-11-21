/// Base repository interface for data access
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<int> create(T item);
  Future<int> update(T item);
  Future<int> delete(int id);
}
