class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:5050";
  static const String baseUrl = "$serverAddress/api/auth";
  
  // // For iOS Simulator
  // static const String serverAddress = "http://localhost:3000";

  // For iPhone (uncomment if needed)
  // static const String baseUrl = "$serverAddress/api/v1/";
  // static const String imageUrl = "$baseUrl/uploads/";

  // Auth
  static const String login = "/login";
  static const String register = "/register";

}



