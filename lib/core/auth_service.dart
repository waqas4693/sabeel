import 'package:get/get.dart';
import 'package:sabeelapp/data/models/app_user.dart';
import 'package:sabeelapp/services/api_service.dart';

class AuthService extends GetxService {
  final Rx<AppUser?> user = Rx<AppUser?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadStoredUser();
  }

  AppUser? get currentUser => user.value;

  bool get isLoggedIn => currentUser != null && ApiService.isLoggedIn;

  Future<void> _loadStoredUser() async {
    try {
      final userData = ApiService.getUserData();
      if (userData != null) {
        user.value = AppUser.fromJson(userData);
        print('AuthService: Loaded stored user: ${user.value?.email}');
      }
    } catch (e) {
      print('AuthService: Error loading stored user: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await ApiService.signIn(
        email: email,
        password: password,
      );

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Save token and user data
        ApiService.saveToken(token);
        ApiService.saveUserData(userData);

        // Update current user
        user.value = AppUser.fromJson(userData);

        print('AuthService: User signed in successfully: ${user.value?.email}');
        return true;
      }
      return false;
    } catch (e) {
      print('AuthService: Sign in error: $e');
      return false;
    }
  }

  Future<bool> signUp(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final response = await ApiService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Save token and user data
        ApiService.saveToken(token);
        ApiService.saveUserData(userData);

        // Update current user
        user.value = AppUser.fromJson(userData);

        print('AuthService: User signed up successfully: ${user.value?.email}');
        return true;
      }
      return false;
    } catch (e) {
      print('AuthService: Sign up error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await ApiService.signOut();
    } catch (e) {
      print('AuthService: Sign out error: $e');
    } finally {
      // Clear local data regardless of API call result
      user.value = null;
      ApiService.clearStorage();
      print('AuthService: User signed out');
    }
  }

  Future<void> refreshUser() async {
    try {
      final response = await ApiService.getCurrentUser();
      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        ApiService.saveUserData(userData);
        user.value = AppUser.fromJson(userData);
      }
    } catch (e) {
      print('AuthService: Error refreshing user: $e');
      // If refresh fails, user might need to sign in again
      await signOut();
    }
  }
}
