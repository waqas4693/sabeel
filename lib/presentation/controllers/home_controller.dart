import 'package:get/get.dart';

class HomeController extends GetxController {
  void showWelcomeMessage() {
    Get.snackbar(
      'Hello',
      'Welcome to GetX!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
