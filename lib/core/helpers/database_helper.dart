import 'dart:developer';

import 'package:sqflite/sqflite.dart';

/// Interface de cache que permite injeção de fakes nos testes sem depender
/// do tipo [Database] do sqflite.
abstract class DatabaseHelperBase {
  Future<CacheEntry?> get({required String key});
  Future<void> upsert({required String key, required String jsonData});
  Future<void> delete({required String key});
  Future<void> clearAll();
}

/// Singleton responsável pelo acesso ao banco SQLite local.
///
/// Armazena pares [key] → [jsonData] com timestamp [updatedAt] (Unix ms)
/// para suportar cache com TTL de qualquer datasource do app.
///
/// Uso:
/// ```dart
/// final db = DatabaseHelper.instance;
/// await db.upsert(key: 'episode_28', jsonData: '{"id":28,...}');
/// final entry = await db.get(key: 'episode_28');
/// ```
class DatabaseHelper extends DatabaseHelperBase {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;

  DatabaseHelper._internal();

  static const String _dbName = 'rick_morty_cache.db';
  static const int _dbVersion = 1;
  static const String _table = 'cache';

  Database? _database;

  /// Retorna a instância do banco, abrindo-o se necessário.
  Future<Database> get database async {
    _database ??= await _openDatabase();
    return _database!;
  }

  // ── Inicialização ───────────────────────────────────────────────────────

  Future<Database> _openDatabase() async {
    final String path = '${await getDatabasesPath()}/$_dbName';

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        key       TEXT PRIMARY KEY,
        json_data TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    log('Cache database created', name: 'DatabaseHelper');
  }

  // ── Operações CRUD ──────────────────────────────────────────────────────

  /// Insere ou atualiza uma entrada de cache.
  ///
  /// [key] identificador único (ex: `"episode_28"`, `"characters_1,2,4"`).
  /// [jsonData] JSON serializado como String.
  Future<void> upsert({
    required String key,
    required String jsonData,
  }) async {
    final db = await database;
    final int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(
      _table,
      {
        'key': key,
        'json_data': jsonData,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log('Cache upserted: $key', name: 'DatabaseHelper');
  }

  /// Retorna a entrada de cache para [key], ou `null` se não existir.
  Future<CacheEntry?> get({required String key}) async {
    final db = await database;

    final List<Map<String, dynamic>> rows = await db.query(
      _table,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return CacheEntry.fromMap(rows.first);
  }

  /// Remove a entrada de cache para [key].
  Future<void> delete({required String key}) async {
    final db = await database;
    await db.delete(_table, where: 'key = ?', whereArgs: [key]);
  }

  /// Apaga todo o cache.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(_table);
    log('Cache cleared', name: 'DatabaseHelper');
  }
}

// ── Value object ────────────────────────────────────────────────────────────

/// Entrada retornada pelo [DatabaseHelper].
class CacheEntry {
  const CacheEntry({
    required this.key,
    required this.jsonData,
    required this.updatedAt,
  });

  final String key;

  /// JSON serializado.
  final String jsonData;

  /// Instante da última atualização.
  final DateTime updatedAt;

  factory CacheEntry.fromMap(Map<String, dynamic> map) {
    return CacheEntry(
      key: map['key'] as String,
      jsonData: map['json_data'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  /// Retorna `true` se o cache ainda está dentro do TTL informado.
  bool isValid({Duration ttl = const Duration(minutes: 1)}) {
    return DateTime.now().difference(updatedAt) < ttl;
  }

  /// Segundos restantes até o cache expirar. Retorna 0 se já expirou.
  int secondsUntilExpiry({Duration ttl = const Duration(minutes: 1)}) {
    final int remaining =
        ttl.inSeconds - DateTime.now().difference(updatedAt).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }
}
