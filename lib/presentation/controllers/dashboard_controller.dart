import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:sabeelapp/services/ai_service.dart';
import 'package:sabeelapp/data/models/ai_response_model.dart';
import 'package:sabeelapp/core/auth_service.dart';

class DashboardController extends GetxController {
  final RxBool isDrawerOpen = true.obs;
  var selectedIndex = 0.obs;
  final _box = GetStorage();

  // --- Journey State ---
  var currentMainStep = 0.obs;
  var currentSubStep = 0.obs;
  var answers = <String, String>{}.obs;
  var showStepModal = false.obs;

  // --- AI Service ---
  late AIService _aiService;
  late AuthService _authService;
  var aiResponse = Rx<AIResponse?>(null);
  var isProcessingAI = false.obs;

  late TextEditingController textEditingController;

  @override
  void onInit() {
    super.onInit();
    _loadProgress();
    _aiService = Get.find<AIService>();
    _authService = Get.find<AuthService>();
    textEditingController = TextEditingController(
      text: _getCurrentAnswer() ?? '',
    );
  }

  void _loadProgress() {
    currentMainStep.value = _box.read('currentMainStep') ?? 0;
    currentSubStep.value = _box.read('currentSubStep') ?? 0;
    answers.value = Map<String, String>.from(_box.read('answers') ?? {});
  }

  void saveProgress() {
    _box.write('currentMainStep', currentMainStep.value);
    _box.write('currentSubStep', currentSubStep.value);
    _box.write('answers', answers);
  }

  void saveAnswer(String key, String value) {
    answers[key] = value;
    saveProgress();
  }

  String? _getCurrentAnswer() {
    return answers['${currentMainStep.value}_${currentSubStep.value}'];
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  void openStepModal() {
    // Load the correct answer for the current step
    textEditingController.text = _getCurrentAnswer() ?? '';
    showStepModal.value = true;
  }

  void closeStepModal() {
    showStepModal.value = false;
  }

  void nextSubStep(int totalSubSteps, int totalMainSteps) {
    // Save current answer before moving
    saveAnswer(
      '${currentMainStep.value}_${currentSubStep.value}',
      textEditingController.text,
    );

    if (currentSubStep.value < totalSubSteps - 1) {
      currentSubStep.value++;
    } else {
      // Last sub-step, move to next main step
      if (currentMainStep.value < totalMainSteps - 1) {
        currentMainStep.value++;
        currentSubStep.value = 0; // Reset sub-step index
      } else {
        // Journey complete!
        currentMainStep.value = totalMainSteps; // Mark as complete
      }
      closeStepModal();
    }
    // Load text for the new step
    textEditingController.text = _getCurrentAnswer() ?? '';
    saveProgress();
  }

  void previousSubStep() {
    // Save current answer before moving
    saveAnswer(
      '${currentMainStep.value}_${currentSubStep.value}',
      textEditingController.text,
    );

    if (currentSubStep.value > 0) {
      currentSubStep.value--;
    }
    // Load text for the new step
    textEditingController.text = _getCurrentAnswer() ?? '';
    saveProgress();
  }

  void resetJourney() {
    currentMainStep.value = 0;
    currentSubStep.value = 0;
    answers.clear();
    saveProgress();
    // Optional: maybe close modal if it's open
    if (showStepModal.value) {
      closeStepModal();
    }
  }

  /// Reset journey state manually (clears AI response too)
  void resetJourneyWithResponse() {
    // Reset all journey state
    currentMainStep.value = 0;
    currentSubStep.value = 0;
    answers.clear();

    // Clear AI response
    aiResponse.value = null;

    // Close any open modals
    if (showStepModal.value) {
      closeStepModal();
    }

    // Update text controller
    textEditingController.text = '';

    // Save the reset state
    saveProgress();

    print('Journey manually reset - ready for new journey');
  }

  // --- AI Processing Methods ---

  /// Process user's response with AI (called when journey is complete)
  Future<void> processCompleteJourney() async {
    isProcessingAI.value = true;

    try {
      // Get current user ID for database storage
      final currentUser = _authService.currentUser;
      final userId = currentUser?.id ?? 'anonymous';

      // Create context for AI processing with all journey answers
      final context = {
        'step_type': 'complete_journey',
        'user_id': userId, // Use actual user ID instead of anonymous
        'answers': answers, // Pass all collected answers
      };

      // Send to AI service
      final response = await _aiService.sendPrompt('complete_journey', context);

      // Update UI
      aiResponse.value = response;

      // Navigate to response page
      Get.toNamed('/response');
    } catch (e) {
      print('Error processing AI response: $e');
      Get.snackbar(
        'Error',
        'Unable to process your response. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessingAI.value = false;
    }
  }

  /// Get journey insight
  Future<void> getJourneyInsight() async {
    isProcessingAI.value = true;

    try {
      final journeyData = {
        'progress': currentMainStep.value,
        'answers_count': answers.length,
        'current_step': currentMainStep.value,
        'answers': answers, // Pass all collected answers
      };

      final insight = await _aiService.getJourneyInsight(journeyData);
      aiResponse.value = insight;
    } catch (e) {
      print('Error getting journey insight: $e');
    } finally {
      isProcessingAI.value = false;
    }
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
