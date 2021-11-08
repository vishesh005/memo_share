import 'package:firebase_auth/firebase_auth.dart';

abstract class Dao{
  static const String srNo = "sr_no";

}

class UserDao extends Dao {

  static const String tableName = "user_info";
  static const String name = "name";
  static const String age = "age";
  static const String userId = "user_id";
  static const String emailAddress = "email_address";
  static const String profilePhotoUrl = "profile_image_url";
  static const String currentLocation = "current_location";

  static String get createTableDefinition {
    return "CREATE TABLE ";
  }


}

class ImageDao extends Dao {

  static const String tableName = "image_table";
  static const String imageId ="image_id";
  static const String imageLocation ="image_location";
  static const String ownerId = "owner_id";

  static String get createTableDefinition{
    return "";
  }

}


class FeedDao extends Dao{

  static const String tableName = "user_feeds_table";
  static const String postedBy = "posted_by";
  static const String comments = "comments";
  static const String likedBy = "liked_by";
  static const String ownerId = "owner_id";
  static const String sharedTo = "shared_to";
  static const String imageId = "image_id";


  static String  get createTableDefinition {
    return "";
  }

}