import 'package:get/get.dart';
import 'package:sabeelapp/services/ai_service.dart';

class AIServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AIService>(() => AIService());
  }
}
