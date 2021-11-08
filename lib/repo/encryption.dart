import 'dart:async';

import 'package:encrypt/encrypt.dart'  as encryptor;
import 'dart:io';

abstract class Encryptor{
  Future<String> encrypt(String key,String data);
  Future<String> decrypt(String key,String encryptedData);
  Future<void> encryptFile(String key,String path);
  Future<void> decryptFile(String key,String path);
}

class EncryptionImpl extends Encryptor{

  @override
  Future<String> decrypt(String key, String encryptedData) async {
    final enKey = encryptor.Key.fromUtf8(key);
    final iv = encryptor.IV.fromLength(16);

    final  enInstance = encryptor.Encrypter(encryptor.AES(enKey));

    return enInstance.decrypt(encryptor.Encrypted.from64(encryptedData),iv: iv);
  }

  @override
  Future<void> decryptFile(String key, String path) {
    // TODO: implement decryptFile
    throw UnimplementedError();
  }

  @override
  Future<String> encrypt(String key,String data) async {
    final enKey = encryptor.Key.fromUtf8(key);
    final iv = encryptor.IV.fromLength(16);

    final  enInstance = encryptor.Encrypter(encryptor.AES(enKey));

    final encrypted = enInstance.encrypt(data.toString(), iv: iv);
    return encrypted.base64;
  }

  @override
  Future<void> encryptFile(String key, String path) {
    final enKey = encryptor.Key.fromUtf8(key);
    final iv = encryptor.IV.fromLength(16);
    final  enInstance = encryptor.Encrypter(encryptor.AES(enKey));
     final file = File(path);
     final encryptedFile = File(path);
     final enSink = encryptedFile.openWrite();
     final _completer = Completer<void>();
     final _stream = file.openRead();
     try {
       _stream.listen((event) {
         final encrypted = enInstance.encryptBytes(event, iv: iv);
         enSink.add(encrypted.bytes);
       },
           onDone: () {
             enSink.flush();
             enSink.close();
             _completer.complete();
           },
         onError: (e){
           enSink.flush();
           enSink.close();
           _completer.completeError(e);
         }
       );
     }catch(e){
     }
     return _completer.future;
  }




}