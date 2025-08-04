import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/shared_preference/token_shared_prefs.dart';
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
import 'package:studyspare_b/feature/course/data/datasource/course_data_source.dart';
import 'package:studyspare_b/feature/course/data/datasource/remote_datasource/course_remote_datasource.dart';
import 'package:studyspare_b/feature/course/data/repository/local_repository/course_remote_repository.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_all_courses_usecase.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_content_by_id_usecase.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_content_for_module_usecase.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_course_by_id_usecase.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_modules_for_course_usecase.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_view_model.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_view_model.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_view_model.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_view_model.dart';
import 'package:studyspare_b/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:studyspare_b/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:studyspare_b/feature/profile/domain/repository/profile_repository.dart';
import 'package:studyspare_b/feature/profile/domain/usecase/delete_user_usecase.dart';
import 'package:studyspare_b/feature/profile/domain/usecase/get_user_profile_usecase.dart';
import 'package:studyspare_b/feature/profile/domain/usecase/update_user_profile_usecase.dart';
import 'package:studyspare_b/feature/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:studyspare_b/feature/task/data/data_source/remote_datasource/task_remote_datasource.dart';
import 'package:studyspare_b/feature/task/data/repository/remote_repository/task_remote_repository.dart';
import 'package:studyspare_b/feature/task/domain/use_case/create_task_usecase.dart';
import 'package:studyspare_b/feature/task/domain/use_case/delete_task_usecase.dart';
import 'package:studyspare_b/feature/task/domain/use_case/get_tasks_usecase.dart';
import 'package:studyspare_b/feature/task/domain/use_case/update_task_usecase.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_view_model.dart';
import 'package:studyspare_b/feature/schedule/data/data_source/remote_datasource/schedule_remote_datasource.dart';
import 'package:studyspare_b/feature/schedule/data/repository/remote_repository/schedule_remote_repository.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/create_schedule_usecase.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/delete_schedule_usecase.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/get_schedules_usecase.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/update_schedule_usecase.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_view_model.dart';
import 'package:studyspare_b/feature/notes/data/data_source/remote_datasource/note_remote_datasource.dart';
import 'package:studyspare_b/feature/notes/data/repository/remote_repository/note_remote_repository.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/create_note_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/get_notes_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/update_note_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/delete_note_usecase.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';
import 'package:studyspare_b/core/services/shake_detection_service.dart';
import 'package:studyspare_b/core/services/double_tap_detection_service.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());

  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());

  await serviceLocator<HiveService>().init();

  // Initialize SharedPreferences first
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  // Register TokenSharedPrefs
  serviceLocator.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );

  // Register ApiService after TokenSharedPrefs
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(serviceLocator<Dio>(), serviceLocator<TokenSharedPrefs>()),
  );

  await _initHomeModule();
  await _initProfileModule();
  await _initScheduleModule();
  await _initNotesModule();
  await initCourseFeature();

  // Register AuthProvider
  serviceLocator.registerLazySingleton<AuthProvider>(
    () => AuthProvider(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );

  // Register ShakeDetectionService
  serviceLocator.registerLazySingleton<ShakeDetectionService>(
    () => ShakeDetectionService(authProvider: serviceLocator<AuthProvider>()),
  );
  // Register DoubleTapDetectionService
  serviceLocator.registerLazySingleton<DoubleTapDetectionService>(
    () =>
        DoubleTapDetectionService(authProvider: serviceLocator<AuthProvider>()),
  );

  await _initAuthModule();
  await _initTaskModule();
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
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future _initHomeModule() async {
  serviceLocator.registerLazySingleton(() => HomeViewModel());
}

Future _initTaskModule() async {
  // Register Task Data Sources
  serviceLocator.registerFactory(
    () => TaskRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Register Task Repositories
  serviceLocator.registerFactory(
    () => TaskRemoteRepository(
      taskRemoteDataSource: serviceLocator<TaskRemoteDatasource>(),
    ),
  );

  // Register Task Use Cases
  serviceLocator.registerFactory(
    () =>
        GetTasksUsecase(taskRepository: serviceLocator<TaskRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => CreateTaskUsecase(
      taskRepository: serviceLocator<TaskRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UpdateTaskUsecase(
      taskRepository: serviceLocator<TaskRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DeleteTaskUsecase(
      taskRepository: serviceLocator<TaskRemoteRepository>(),
    ),
  );

  // Register Task BLoC
  serviceLocator.registerFactory(
    () => TaskViewModel(
      getTasksUsecase: serviceLocator<GetTasksUsecase>(),
      createTaskUsecase: serviceLocator<CreateTaskUsecase>(),
      updateTaskUsecase: serviceLocator<UpdateTaskUsecase>(),
      deleteTaskUsecase: serviceLocator<DeleteTaskUsecase>(),
    ),
  );
}

Future<void> _initScheduleModule() async {
  // Register Schedule Data Source
  serviceLocator.registerFactory(
    () => ScheduleRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Register Schedule Repository
  serviceLocator.registerFactory(
    () => ScheduleRemoteRepository(
      scheduleRemoteDataSource: serviceLocator<ScheduleRemoteDatasource>(),
    ),
  );

  // Register Schedule Use Cases
  serviceLocator.registerFactory(
    () => GetSchedulesUsecase(serviceLocator<ScheduleRemoteRepository>()),
  );
  serviceLocator.registerFactory(
    () => CreateScheduleUsecase(serviceLocator<ScheduleRemoteRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateScheduleUsecase(serviceLocator<ScheduleRemoteRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeleteScheduleUsecase(serviceLocator<ScheduleRemoteRepository>()),
  );

  // Register Schedule Bloc
  serviceLocator.registerFactory(
    () => ScheduleViewModel(
      getSchedulesUsecase: serviceLocator<GetSchedulesUsecase>(),
      createScheduleUsecase: serviceLocator<CreateScheduleUsecase>(),
      updateScheduleUsecase: serviceLocator<UpdateScheduleUsecase>(),
      deleteScheduleUsecase: serviceLocator<DeleteScheduleUsecase>(),
    ),
  );
}

Future<void> _initNotesModule() async {
  serviceLocator.registerFactory(
    () => NoteRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory(
    () => NoteRemoteRepository(
      noteRemoteDatasource: serviceLocator<NoteRemoteDatasource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreateNoteUsecase(
      noteRepository: serviceLocator<NoteRemoteRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () =>
        GetNotesUsecase(noteRepository: serviceLocator<NoteRemoteRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateNoteUsecase(
      noteRepository: serviceLocator<NoteRemoteRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeleteNoteUsecase(
      noteRepository: serviceLocator<NoteRemoteRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => NoteViewModel(
      getNotesUsecase: serviceLocator<GetNotesUsecase>(),
      createNoteUsecase: serviceLocator<CreateNoteUsecase>(),
      updateNoteUsecase: serviceLocator<UpdateNoteUsecase>(),
      deleteNoteUsecase: serviceLocator<DeleteNoteUsecase>(),
    ),
  );
}

Future _initProfileModule() async {
  // Data sources
  serviceLocator.registerLazySingleton<IProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: serviceLocator<IProfileRemoteDataSource>(),
      authProvider: serviceLocator<AuthProvider>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () =>
        GetUserProfileUsecase(repository: serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeleteUserUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => UpdateUserProfileUsecase(
      repository: serviceLocator<IProfileRepository>(),
    ),
  );

  // ViewModel
  serviceLocator.registerFactory(
    () => ProfileCubit(
      getUserProfileUsecase: serviceLocator(),
      updateUserProfileUsecase: serviceLocator(),
      deleteUserUsecase: serviceLocator(),
      authProvider: serviceLocator(),
    ),
  );
}

Future<void> initCourseFeature() async {
  serviceLocator.registerFactory(
    () => CoursesListViewModel(getAllCoursesUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => CourseDetailViewModel(
      getCourseByIdUsecase: serviceLocator(),
      getModulesForCourseUsecase: serviceLocator(),
      getContentForModuleUsecase: serviceLocator(),
    ),
  );

  // --- Domain (Usecases) ---
  serviceLocator.registerLazySingleton(
    () => GetAllCoursesUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCourseByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetModulesForCourseUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetContentForModuleUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetContentByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => ContentViewModel(getContentByIdUsecase: serviceLocator()),
  );
  // --- Data (Repository & DataSource) ---
  serviceLocator.registerLazySingleton<ICourseRepository>(
    () => CourseRemoteRepository(
      remoteDataSource: serviceLocator(),
      authProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<ICourseDataSource>(
    () => CourseRemoteDataSourceImpl(apiService: serviceLocator()),
  );
}
