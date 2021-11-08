

import 'package:get/get.dart';

abstract class ApiClient{
  Future<dynamic> post(Uri uri);
  Future<dynamic> get(Uri uri);
}

class GetApiClient extends GetConnect{

}