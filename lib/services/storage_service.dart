import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class StorageService {
  static Database? _database;
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'lacos.db');

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL,
        foto_url TEXT,
        bio TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Skills table
    await db.execute('''
      CREATE TABLE skills (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        categoria TEXT,
        nivel TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Events table
    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        creator_id TEXT NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT,
        categoria TEXT,
        data INTEGER NOT NULL,
        local TEXT,
        max_participantes INTEGER,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (creator_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Event participants table
    await db.execute('''
      CREATE TABLE event_participants (
        event_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        joined_at INTEGER NOT NULL,
        PRIMARY KEY (event_id, user_id),
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Skill matches table
    await db.execute('''
      CREATE TABLE skill_matches (
        id TEXT PRIMARY KEY,
        user1_id TEXT NOT NULL,
        user2_id TEXT NOT NULL,
        skill1_id TEXT NOT NULL,
        skill2_id TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        created_at INTEGER NOT NULL,
        FOREIGN KEY (user1_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (user2_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (skill1_id) REFERENCES skills (id) ON DELETE CASCADE,
        FOREIGN KEY (skill2_id) REFERENCES skills (id) ON DELETE CASCADE
      )
    ''');

    // Messages table
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        receiver_id TEXT NOT NULL,
        content TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'text',
        sent_at INTEGER NOT NULL,
        read_at INTEGER,
        FOREIGN KEY (sender_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (receiver_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // Token management
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Current user management
  Future<void> saveCurrentUser(Usuario user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));

    // Also save to database
    final db = await database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Usuario?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return Usuario.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Users management
  Future<void> saveUsers(List<Usuario> users) async {
    final db = await database;
    final batch = db.batch();

    for (final user in users) {
      batch.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<Usuario>> getUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((map) => Usuario.fromJson(map)).toList();
  }

  // Skills management
  Future<void> saveSkill(Habilidade skill) async {
    final db = await database;
    await db.insert(
      'skills',
      skill.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habilidade>> getUserSkills(String userId) async {
    final db = await database;
    final maps = await db.query(
      'skills',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => Habilidade.fromJson(map)).toList();
  }

  Future<List<Habilidade>> getAllSkills() async {
    final db = await database;
    final maps = await db.query('skills');
    return maps.map((map) => Habilidade.fromJson(map)).toList();
  }

  Future<void> deleteSkill(String skillId) async {
    final db = await database;
    await db.delete('skills', where: 'id = ?', whereArgs: [skillId]);
  }

  // Events management
  Future<void> saveEvent(Evento event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Evento>> getAllEvents() async {
    final db = await database;
    final maps = await db.query('events', orderBy: 'data ASC');
    return maps.map((map) => Evento.fromJson(map)).toList();
  }

  Future<List<Evento>> getUserEvents(String userId) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'creator_id = ?',
      whereArgs: [userId],
      orderBy: 'data ASC',
    );
    return maps.map((map) => Evento.fromJson(map)).toList();
  }

  Future<void> deleteEvent(String eventId) async {
    final db = await database;
    await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  // Event participants
  Future<void> addEventParticipant(String eventId, String userId) async {
    final db = await database;
    await db.insert('event_participants', {
      'event_id': eventId,
      'user_id': userId,
      'joined_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeEventParticipant(String eventId, String userId) async {
    final db = await database;
    await db.delete(
      'event_participants',
      where: 'event_id = ? AND user_id = ?',
      whereArgs: [eventId, userId],
    );
  }

  Future<List<String>> getEventParticipants(String eventId) async {
    final db = await database;
    final maps = await db.query(
      'event_participants',
      columns: ['user_id'],
      where: 'event_id = ?',
      whereArgs: [eventId],
    );
    return maps.map((map) => map['user_id'] as String).toList();
  }

  // Clear all data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final db = await database;
    await db.delete('users');
    await db.delete('skills');
    await db.delete('events');
    await db.delete('event_participants');
    await db.delete('skill_matches');
    await db.delete('messages');
  }

  // Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
