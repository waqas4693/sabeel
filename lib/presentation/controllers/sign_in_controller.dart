import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sabeelapp/core/auth_service.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> signIn() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Starting sign in process...');
      print('Attempting to sign in with email: ${emailController.text.trim()}');

      final success = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text,
      );

      if (success) {
        print('User signed in successfully');
        return true;
      } else {
        errorMessage.value =
            'Sign in failed. Please check your credentials and try again.';
        return false;
      }
    } catch (e) {
      print('Sign in error: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Starting sign up process...');
      print('Attempting to sign up with email: ${emailController.text.trim()}');

      final success = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text,
        displayName: emailController.text.trim().split('@')[0],
      );

      if (success) {
        print('User signed up successfully');
        return true;
      } else {
        errorMessage.value = 'Sign up failed. Please try again.';
        return false;
      }
    } catch (e) {
      print('Sign up error: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
