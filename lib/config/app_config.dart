class AppConfig {
  // Environment configuration
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  // Base URLs for different environments
  static const Map<String, String> _baseUrls = {
    'development': 'https://sabeel-server.vercel.app/api',
    'staging': 'https://sabeel-server.vercel.app/api',
    'production': 'https://sabeel-server.vercel.app/api',
  };

  // Get the appropriate base URL based on environment
  static String get baseUrl =>
      _baseUrls[environment] ?? _baseUrls['development']!;

  // API timeout settings
  static const Duration apiTimeout = Duration(seconds: 30);

  // Debug settings
  static bool get isDebugMode => environment == 'development';

  // Log API requests in debug mode
  static bool get shouldLogRequests => isDebugMode;
}
