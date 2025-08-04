class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "http://localhost:5050";
  static const String baseUrl = "$serverAddress/api";

  // // For iOS Simulator
  // static const String serverAddress = "http://localhost:3000";

  // For iPhone (uncomment if needed)
  // static const String baseUrl = "$serverAddress/api/v1/";
  // static const String imageUrl = "$baseUrl/uploads/";

  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";

  // Tasks
  static const String tasks = "/tasks";

  // Notes
  static const String notes = "/notes";

  // Schedules
  static const String schedules = "/schedule";

  static const String profile = "/profile/me";

  static const String courses = "/courses";
  static const String modules = "/modules";
  static const String content = "/modules/content";
}
