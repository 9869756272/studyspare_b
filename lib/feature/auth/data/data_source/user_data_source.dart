
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';

abstract interface class IuserDataSource{
  Future<void> registerUser (UserEntity userData);


   Future<String> loginUser(String username, String password);

}