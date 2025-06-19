
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyspare_b/app/constant/hive_table_constant.dart';
import 'package:studyspare_b/feature/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async{

    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}user_managament.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());

   

  }
   Future <void> register(UserHiveModel auth) async {
      var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
      await box.put(auth.userId, auth);
    }
    Future <void> deleteAuth(String id) async {
      var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
      await box.delete(id);
    }
    Future <List<UserHiveModel>> getAllAUth() async{
      var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
      return  box.values.toList();

    }

    Future<UserHiveModel?> loginUser(String username, String password) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.userBox,
    );
    var student = box.values.firstWhere(
      (element) => element.username == username && element.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );
    box.close();
    return student;
  }


}