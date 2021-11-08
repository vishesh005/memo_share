import 'package:memo_share/repo/dao.dart';
import 'package:memo_share/repo/repository.dart';
import 'package:sqflite/sqflite.dart' as mobile;
import 'encryption.dart';

class SQLiteDb extends RDatabase {
  final int _version = 1;

  mobile.Database? _database;

  SQLiteDb(String dbPath, Encryptor encryptor) : super(dbPath, encryptor);

  @override
  Future<void> openDatabase() async {
    if (_database == null || !_database!.isOpen) {
      await encryptor.decryptFile("123", currentDbPath);
      _database = await mobile.openDatabase(currentDbPath,
          version: _version, onCreate: _onCreateDb);
    }
  }

  @override
  Future<void> closeDatabase() async {
    await encryptor.encryptFile("123", currentDbPath);
    await _database?.close();
  }

  @override
  Future<int> deleteRecord(String tableName, String deleteWhere, List<Object> whereArguments) async {
    return await _database?.delete(tableName, where: deleteWhere, whereArgs: whereArguments) ?? -1;
  }

  @override
  Future<int> insertRecord(String tableName, Map<String, dynamic> row,
      {Conflict conflict = Conflict.abort}) async {
    mobile.ConflictAlgorithm algo;

    switch (conflict) {
      case Conflict.replace:
        algo = mobile.ConflictAlgorithm.replace;
        break;
      case Conflict.fail:
        algo = mobile.ConflictAlgorithm.fail;
        break;
      case Conflict.rollback:
        algo = mobile.ConflictAlgorithm.rollback;
        break;
      default:
        algo = mobile.ConflictAlgorithm.abort;
        break;
    }
    return await _database?.insert(tableName, row, conflictAlgorithm: algo) ?? -1;
  }

  @override
  Future<dynamic> searchQuery(String tableName,Object selectClause ,Object whereCondition) async {
    return await _database?.query("SELECT $selectClause from $tableName where $whereCondition");
  }

  @override
  Future<int> updateRecord(String tableName, Map<String, dynamic> newRecord, dynamic whereCondition,
      {List<Object> whereArguments = const [] , Conflict conflict = Conflict.abort}) async {
    return await _database?.update(tableName,newRecord,where:  whereCondition.toString(), whereArgs: whereArguments) ?? -1;
  }

  Future<void> _onCreateDb(mobile.Database db, int version) async {
    _database = db;
    await _database?.rawQuery(UserDao.createTableDefinition);
    await _database?.rawQuery(ImageDao.createTableDefinition);
    await _database?.rawQuery(FeedDao.createTableDefinition);
  }
}
