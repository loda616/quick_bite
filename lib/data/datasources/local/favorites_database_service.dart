import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritesDatabaseService {
  static const String _databaseName = 'favorites.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'favorites';
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        food_id TEXT PRIMARY KEY,
        added_at INTEGER NOT NULL
      )
    ''');
  }
  
  Future<void> addFavorite(String foodId) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'food_id': foodId,
        'added_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<void> removeFavorite(String foodId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'food_id = ?',
      whereArgs: [foodId],
    );
  }
  
  Future<bool> isFavorite(String foodId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'food_id = ?',
      whereArgs: [foodId],
    );
    return result.isNotEmpty;
  }
  
  Future<List<String>> getAllFavoriteIds() async {
    final db = await database;
    final result = await db.query(
      _tableName,
      orderBy: 'added_at DESC',
    );
    return result.map((row) => row['food_id'] as String).toList();
  }
  
  Future<void> clearAllFavorites() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
