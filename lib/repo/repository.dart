import 'package:memo_share/repo/dao.dart';
import 'encryption.dart';

abstract class Repository{
   UserDao getUserDao();
   FeedDao getFeedDao();
}

class RepositoryImpl extends Repository {

  @override
  FeedDao getFeedDao() {
    return FeedDao();
  }

  @override
  UserDao getUserDao() {
     return UserDao();
  }
}


abstract class RDatabase {

  final Encryptor encryptor;
  final String currentDbPath;

   RDatabase(this.currentDbPath,this.encryptor);

   Future<void> openDatabase();
   Future<void> closeDatabase();
   Future<dynamic> searchQuery(String tableName,Object selectClause ,Object whereCondition);
   Future<int> insertRecord(String tableName, Map<String,dynamic> row,{Conflict conflict});
   Future<int> deleteRecord(String tableName,String deleteWhere,List<Object> whereArguments);
   Future<int> updateRecord(String tableName,Map<String,dynamic> newRecord, dynamic whereCondition);

}

enum Conflict{
  replace , fail , abort, rollback
}

abstract class AppPreference {

  final Encryptor _encryptor;

  AppPreference(this._encryptor);

   Future<void> saveString(String key, String value);
   Future<void> saveInt(String key, int value);
   Future<void> saveBool(String key,bool value);
   Future<void> saveDouble(String key, double value);
   Future<void> saveListOfString(String key,List<String> list);

}

