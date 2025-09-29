import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sabeelapp/config/app_config.dart';

class ApiService {
  static final GetStorage _storage = GetStorage();

  // Headers for authenticated requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_storage.hasData('auth_token'))
      'Authorization': 'Bearer ${_storage.read('auth_token')}',
  };

  // Generic HTTP methods
  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
      http.Response response;

      if (AppConfig.shouldLogRequests) {
        print('API Request: $method $url');
        if (body != null) print('Request Body: ${json.encode(body)}');
      }

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: _headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: _headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (AppConfig.shouldLogRequests) {
        print('API Response: ${response.statusCode} ${response.body}');
      }

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Request failed');
      }
    } catch (e) {
      if (AppConfig.shouldLogRequests) {
        print('API Request Error: $e');
      }
      rethrow;
    }
  }

  // Authentication methods
  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await _makeRequest(
      'POST',
      '/auth/signup',
      body: {
        'email': email,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      },
    );
  }

  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    return await _makeRequest(
      'POST',
      '/auth/signin',
      body: {'email': email, 'password': password},
    );
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    return await _makeRequest('GET', '/auth/me');
  }

  static Future<void> signOut() async {
    try {
      await _makeRequest('POST', '/auth/signout');
    } finally {
      // Always clear local storage even if API call fails
      _storage.remove('auth_token');
      _storage.remove('user_data');
    }
  }

  // AI methods
  static Future<Map<String, dynamic>> getAIInsight({
    required String userInputSelfReflection,
    required String userInputDivineSigns,
    required String userInputTalents,
    required String userInputService,
  }) async {
    return await _makeRequest(
      'POST',
      '/ai/insight',
      body: {
        'user_input_self_reflection': userInputSelfReflection,
        'user_input_divine_signs': userInputDivineSigns,
        'user_input_talents': userInputTalents,
        'user_input_service': userInputService,
      },
    );
  }

  static Future<Map<String, dynamic>> getAIHistory({
    int page = 1,
    int limit = 10,
  }) async {
    return await _makeRequest('GET', '/ai/history?page=$page&limit=$limit');
  }

  // Token management
  static void saveToken(String token) {
    _storage.write('auth_token', token);
  }

  static String? getToken() {
    return _storage.read('auth_token');
  }

  static void saveUserData(Map<String, dynamic> userData) {
    _storage.write('user_data', userData);
  }

  static Map<String, dynamic>? getUserData() {
    return _storage.read('user_data');
  }

  static bool get isLoggedIn => _storage.hasData('auth_token');

  static void clearStorage() {
    _storage.remove('auth_token');
    _storage.remove('user_data');
  }
}
