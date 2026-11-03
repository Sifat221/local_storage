import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> openMyDatabase() async {
    String folder = await getDatabasesPath();
    String path = join(folder, 'module9_contacts.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            email TEXT NOT NULL,
            address TEXT NOT NULL,
            isFavorite INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> addContact(Map<String, dynamic> contact) async {
    Database db = await openMyDatabase();

    await db.insert('contacts', contact);
  }

  Future<List<Map<String, dynamic>>> readContacts(
      String searchText,
      bool showFavoritesOnly,
      ) async {
    Database db = await openMyDatabase();

    String where = 'name LIKE ?';
    List<dynamic> whereArgs = ['%$searchText%'];

    if (showFavoritesOnly) {
      where = '$where AND isFavorite = ?';
      whereArgs.add(1);
    }

    List<Map<String, dynamic>> rows = await db.query(
      'contacts',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'name ASC',
    );

    return rows;
  }

  Future<void> updateContact(
      int id,
      Map<String, dynamic> contact,
      ) async {
    Database db = await openMyDatabase();

    await db.update(
      'contacts',
      contact,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteContact(int id) async {
    Database db = await openMyDatabase();

    await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFavorite(int id, int favoriteValue) async {
    Database db = await openMyDatabase();

    await db.update(
      'contacts',
      {'isFavorite': favoriteValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}