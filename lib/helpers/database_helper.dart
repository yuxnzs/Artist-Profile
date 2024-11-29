import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Private empty constructor to initialize the singleton
  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database and create the history table
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'search_history.db');
    return await openDatabase(
      path,
      version: 1,
      // onCreate is called if the database is not yet created
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            searchText TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Add a new search history to the database
  Future<void> addHistory(String searchText) async {
    final db = await database;

    // Check if the search text is already in the database
    final existingHistory = await db.query(
      'history',
      where: 'searchText = ?',
      whereArgs: [searchText],
    );

    // If the search text is already in the database, update the timestamp to display at the top
    if (existingHistory.isNotEmpty) {
      // existingHistory.first['id'] is dynamic, need to cast it to int
      await updateTimestamp(
        id: existingHistory.first['id'] as int,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      await db.insert(
        'history',
        {
          'searchText': searchText,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    }
  }

  // Delete a search history from the database
  Future<void> deleteHistory(int id) async {
    final db = await database;
    await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id], // Prevent SQL injection
    );
  }

  // Update the timestamp of a search history to display the most recent search at the top
  Future<void> updateTimestamp({
    required int id,
    required int timestamp,
  }) async {
    final db = await database;
    await db.update(
      'history',
      {'timestamp': timestamp},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all search history from the database for display
  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query(
      'history',
      orderBy: 'timestamp DESC',
    ); // New search history at the top
  }
}
