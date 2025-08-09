import 'package:sqflite/sqflite.dart';
import 'dart:developer';

import '../../../domain/entities/article.dart';
import '../../../core/storage/database_helper.dart';
import '../../models/article_sqlite_model.dart';

abstract class SQLiteNewsSource {
  Future<void> initialize();
  Future<List<Article>> getArticles({
    String? category,
    String? sourceId,
    int? limit,
    int? offset,
    String? orderBy,
  });
  Future<void> saveArticles(List<Article> articles);
  Future<List<Article>> searchArticles(
    String query, {
    int? limit,
    int? offset,
  });
  Future<void> toggleBookmark(String articleId);
  Future<List<Article>> getBookmarkedArticles();
  Future<void> clearCache();
  Future<int> getCacheSize();
}

class SQLiteNewsSourceImpl implements SQLiteNewsSource {
  late final Database _database;

  @override
  Future<void> initialize() async {
    try {
      _database = await DatabaseHelper.database;
      log('SQLite news source initialized successfully');
    } catch (e) {
      log('Failed to initialize SQLite news source: $e');
      rethrow;
    }
  }

  @override
  Future<List<Article>> getArticles({
    String? category,
    String? sourceId,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    try {
      final buffer = StringBuffer('''
        SELECT a.*, 
               CASE WHEN b.article_id IS NOT NULL THEN 1 ELSE 0 END as is_bookmarked
        FROM articles a
        LEFT JOIN bookmarks b ON a.id = b.article_id
        WHERE 1=1
      ''');
      
      final arguments = <dynamic>[];

      if (category != null && category.isNotEmpty) {
        buffer.write(' AND a.categories LIKE ?');
        arguments.add('%$category%');
      }

      if (sourceId != null && sourceId.isNotEmpty) {
        buffer.write(' AND a.source_id = ?');
        arguments.add(sourceId);
      }

      buffer.write(' ORDER BY ${orderBy ?? 'a.published_at'} DESC');

      if (limit != null) {
        buffer.write(' LIMIT ?');
        arguments.add(limit);
      }

      if (offset != null) {
        buffer.write(' OFFSET ?');
        arguments.add(offset);
      }

      final result = await _database.rawQuery(buffer.toString(), arguments);
      
      return result
          .map((row) => ArticleSQLiteModel.fromMap(row).toDomain())
          .toList();
    } catch (e) {
      log('Failed to get articles from SQLite: $e');
      return [];
    }
  }

  @override
  Future<void> saveArticles(List<Article> articles) async {
    try {
      final batch = _database.batch();

      for (final article in articles) {
        final model = ArticleSQLiteModel.fromDomain(article);
        batch.insert(
          'articles',
          model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit();
      log('Saved ${articles.length} articles to SQLite');
    } catch (e) {
      log('Failed to save articles to SQLite: $e');
    }
  }

  @override
  Future<List<Article>> searchArticles(
    String query, {
    int? limit,
    int? offset,
  }) async {
    try {
      // Create FTS query - escape quotes and prepare for full-text search
      final searchQuery = query.split(' ')
          .map((term) => '"${term.replaceAll('"', '""')}"')
          .join(' OR ');
      
      final result = await _database.rawQuery('''
        SELECT a.*, 
               CASE WHEN b.article_id IS NOT NULL THEN 1 ELSE 0 END as is_bookmarked,
               snippet(articles_fts, 0, '<mark>', '</mark>', '...', 32) as title_snippet,
               snippet(articles_fts, 1, '<mark>', '</mark>', '...', 64) as description_snippet,
               bm25(articles_fts) as rank
        FROM articles a
        LEFT JOIN bookmarks b ON a.id = b.article_id
        JOIN articles_fts ON articles_fts.rowid = a.rowid
        WHERE articles_fts MATCH ?
        ORDER BY rank, a.published_at DESC
        LIMIT ? OFFSET ?
      ''', [searchQuery, limit ?? 50, offset ?? 0]);

      return result
          .map((row) => ArticleSQLiteModel.fromMap(row).toDomain())
          .toList();
    } catch (e) {
      log('Failed to search articles in SQLite: $e');
      
      // Fallback to simple LIKE search if FTS fails
      return _fallbackSearch(query, limit: limit, offset: offset);
    }
  }

  Future<List<Article>> _fallbackSearch(
    String query, {
    int? limit,
    int? offset,
  }) async {
    try {
      final result = await _database.rawQuery('''
        SELECT a.*, 
               CASE WHEN b.article_id IS NOT NULL THEN 1 ELSE 0 END as is_bookmarked
        FROM articles a
        LEFT JOIN bookmarks b ON a.id = b.article_id
        WHERE a.title LIKE ? OR a.description LIKE ? OR a.content LIKE ?
        ORDER BY a.published_at DESC
        LIMIT ? OFFSET ?
      ''', [
        '%$query%',
        '%$query%',
        '%$query%',
        limit ?? 50,
        offset ?? 0,
      ]);

      return result
          .map((row) => ArticleSQLiteModel.fromMap(row).toDomain())
          .toList();
    } catch (e) {
      log('Fallback search also failed: $e');
      return [];
    }
  }

  @override
  Future<void> toggleBookmark(String articleId) async {
    try {
      final existing = await _database.query(
        'bookmarks',
        where: 'article_id = ?',
        whereArgs: [articleId],
      );

      if (existing.isNotEmpty) {
        await _database.delete(
          'bookmarks',
          where: 'article_id = ?',
          whereArgs: [articleId],
        );
        log('Removed bookmark for article: $articleId');
      } else {
        await _database.insert(
          'bookmarks',
          {
            'article_id': articleId,
            'created_at': DateTime.now().millisecondsSinceEpoch,
          },
        );
        log('Added bookmark for article: $articleId');
      }
    } catch (e) {
      log('Failed to toggle bookmark in SQLite: $e');
    }
  }

  @override
  Future<List<Article>> getBookmarkedArticles() async {
    try {
      final result = await _database.rawQuery('''
        SELECT a.*, 1 as is_bookmarked
        FROM articles a
        INNER JOIN bookmarks b ON a.id = b.article_id
        ORDER BY b.created_at DESC
      ''');

      return result
          .map((row) => ArticleSQLiteModel.fromMap(row).toDomain())
          .toList();
    } catch (e) {
      log('Failed to get bookmarked articles from SQLite: $e');
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _database.delete('articles');
      log('Cleared SQLite articles cache');
    } catch (e) {
      log('Failed to clear SQLite cache: $e');
    }
  }

  @override
  Future<int> getCacheSize() async {
    try {
      final result = await _database.rawQuery('SELECT COUNT(*) as count FROM articles');
      return (result.first['count'] as int?) ?? 0;
    } catch (e) {
      log('Failed to get SQLite cache size: $e');
      return 0;
    }
  }
}
