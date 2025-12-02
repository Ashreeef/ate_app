import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/post.dart';

class PostRepository {
  final dbHelper = DatabaseHelper();

  Future<Post> createPost(Post post) async {
    final db = await dbHelper.db;
    int id = await db.insert('posts', post.toMap());
    post.id = id;
    return post;
  }

  Future<List<Post>> getPosts({int page = 1, int pageSize = 10}) async {
    final db = await dbHelper.db;
    final offset = (page - 1) * pageSize;
    final result = await db.query('posts', orderBy: 'createdAt DESC', limit: pageSize, offset: offset);
    return result.map((e) => Post.fromMap(e)).toList();
  }

  Future<void> updatePost(Post post) async {
    final db = await dbHelper.db;
    await db.update('posts', post.toMap(), where: 'id = ?', whereArgs: [post.id]);
  }

  Future<Post?> getPostById(int id) async {
    final db = await dbHelper.db;
    final res = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) return Post.fromMap(res.first);
    return null;
  }
}
