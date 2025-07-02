
// import 'package:get_it/get_it.dart';
// import 'package:studyspare_b/core/network/hive_service.dart';
// import 'package:studyspare_b/feature/auth/data/data_source/local_datasource/user_local_datasource.dart';
// import 'package:studyspare_b/feature/auth/data/repository/local_repository/user_local_repository.dart';
// import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';
// import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';
// import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';


// final serviceLocator = GetIt.instance;

// Future<void> initDependencies() async {
//   // First register HiveService
//   serviceLocator.registerLazySingleton<HiveService>(() => HiveService());

//   // Then initialize Hive
//   await serviceLocator<HiveService>().init();

//   // After Hive is ready, initialize auth module
//   await _initAuthModule();
// }

// Future<void> _initAuthModule() async {
//   // Data Source
//   serviceLocator.registerFactory(
//     () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
//   );

//   // Repository
//   serviceLocator.registerFactory(
//     () => UserLocalRepository(
//       userLocalDatasource: serviceLocator<UserLocalDatasource>(),
//     ),
//   );

//   // UseCases
//   serviceLocator.registerFactory(
//     () => UserRegisterUsecase(
//       userReposiotry: serviceLocator<UserLocalRepository>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => UserLoginUsecase(
//       userRepository: serviceLocator<UserLocalRepository>(),
//     ),
//   );

//   // ViewModels
//   serviceLocator.registerLazySingleton(
//     () => RegisterViewModel(
//       registerUsecase: serviceLocator<UserRegisterUsecase>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
//   );
// }



// import 'package:fashora_app/core/network/api_network.dart';
// import 'package:fashora_app/core/network/hive_service.dart';
// import 'package:fashora_app/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
// import 'package:fashora_app/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
// import 'package:fashora_app/features/auth/data/repository/local_repository/user_local_repository.dart';
// import 'package:fashora_app/features/auth/data/repository/remote_repository/user_remote_repository.dart';
// import 'package:fashora_app/features/auth/domain/use_case/user_login_usecase.dart';
// import 'package:fashora_app/features/auth/domain/use_case/user_register_usecase.dart';
// import 'package:fashora_app/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:fashora_app/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
// import 'package:get_it/get_it.dart';


// final serviceLocator = GetIt.instance;

// Future<void> initDependencies() async {
//   // First register HiveService
//   serviceLocator.registerLazySingleton<HiveService>(() => HiveService());

//   // Then initialize Hive
//   await serviceLocator<HiveService>().init();

//   // After Hive is ready, initialize auth module
//   await _initAuthModule();
// }

// Future<void> _initAuthModule() async {
//   // Data Source
//   serviceLocator.registerFactory(
//     () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
//   );

//   //api 

//   serviceLocator.registerFactory(
//     () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
//   );

//   // Repository
//   serviceLocator.registerFactory(
//     () => UserLocalRepository(
//       userLocalDatasource: serviceLocator<UserLocalDatasource>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => UserRemoteRepository(
//       userRemoteDataSource: serviceLocator<UserRemoteDatasource>(),
//     ),
//   );

//   // UseCases
//   serviceLocator.registerFactory(
//     () => UserRegisterUsecase(
//       userReposiotry: serviceLocator<UserRemoteRepository>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => UserLoginUsecase(
//       userRepository: serviceLocator<UserRemoteRepository>(),
//     ),
//   );

//   // ViewModels
//   serviceLocator.registerLazySingleton(
//     () => RegisterViewModel(
//       registerUsecase: serviceLocator<UserRegisterUsecase>(),
//     ),
//   );

//   serviceLocator.registerFactory(
//     () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
//   );
// }



import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:studyspare_b/core/network/api_service.dart';
import 'package:studyspare_b/core/network/hive_service.dart';
import 'package:studyspare_b/feature/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:studyspare_b/feature/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:studyspare_b/feature/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:studyspare_b/feature/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {

  serviceLocator.registerLazySingleton<Dio>(() => Dio());


  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());


  await serviceLocator<HiveService>().init();


  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(serviceLocator<Dio>()),
  );


  await _initAuthModule();
}

Future<void> _initAuthModule() async {

  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

 
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDataSource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

 
  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userReposiotry: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

 
  serviceLocator.registerLazySingleton(
    () => RegisterViewModel(
      registerUsecase: serviceLocator<UserRegisterUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(
      serviceLocator<UserLoginUsecase>(),
    ),
  );
}


