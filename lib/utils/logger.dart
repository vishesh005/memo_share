import 'dart:async';
import 'dart:io';
import 'package:memo_share/base/config.dart';
import 'package:memo_share/repo/network_client.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


class Logger{

   static final Logger _instance = Logger._internal();
   factory Logger()=> _instance;
   Logger._internal();

   Uri? _apiSyncUri;
   ApiClient? _client;
   Directory? _fileDir;
   BackupPolicy _policy =  const BackupPolicy(2, Frequency.daily);
   Frequency _syncFrequency =  Frequency.daily;
   bool _enableWeb = false;

   String get _newFileName => "$appName-logfile-${DateTime.now().toIso8601String()}.log";
   final String _logDir = "logs";



   Future<void> init() async {
      _fileDir = Directory(path.join((await getApplicationDocumentsDirectory()).path, _logDir));
      if(!(await _fileDir!.exists())){
         await _fileDir!.create();
      }
       await _checkBackUpPolicyAndSync(_fileDir!);
   }

   Future<void> _checkBackUpPolicyAndSync(Directory dir) async {
       final _jobCompleter = Completer.sync();
       dir.list().listen((fileEntity) {
           final fileName = path.basename(fileEntity.path);
             if(fileName.isValidLogFile()) {
               final date = fileName.split("-")[3];
               final fileDateTime = DateTime.parse(date);
             }
        },
         onDone: (){
            _jobCompleter.complete();
         },
          onError: (e){
            _jobCompleter.completeError(e);
          },
          cancelOnError: true
       );
      return _jobCompleter.future;
   }

   void setApiSyncUrl(Uri uri){
      _apiSyncUri = uri;
   }

   void setBackupPolicy(BackupPolicy policy){
      _policy = policy;
   }

   void setSyncFrequency(Frequency frequency){
      _syncFrequency = frequency;
   }

   void setNetworkClient(ApiClient client){
       _client = client;
   }

   /// If you have enabled logger then it will sync logs every on every api request
   /// on Flutter Web application
   void enableOnWeb(bool webEnable){
      _enableWeb = webEnable;
   }



}

class BackupPolicy{
   final double maxFileInMb;
   final Frequency backUpFrequency;
   const BackupPolicy(this.maxFileInMb,this.backUpFrequency);
}

enum Frequency{
   daily, weekly, monthly
}

extension on String {
  bool isValidLogFile(){
      final list = split("-");
      if(list.length < 3) return false;
      return DateTime.tryParse(list[2]) != null;
  }
}