import 'package:equatable/equatable.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:studyspare_b/app/constant/hive_table_constant.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';
@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable{
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;


  UserHiveModel({
    String? userId,
    required this.username,
    required this.email,
  
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  const UserHiveModel.intial()
  : userId = '',
  username = '',
  email = '',
  password = '';

  factory UserHiveModel.fromEntity(UserEntity entity){
    return UserHiveModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      password: entity.password,

    );
  }

  UserEntity toEntity(){
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      password:  password,

    );
  }


  @override
  // TODO: implement props
  List<Object?> get props => [

    userId,
    username,
    email,
    password

  ] ;
}