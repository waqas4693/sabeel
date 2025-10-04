import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabeelapp/presentation/controllers/dashboard_controller.dart';
import 'package:sabeelapp/presentation/widgets/gradient_action_button.dart';

class ResponsePage extends GetView<DashboardController> {
  const ResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A61),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3A61),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Your Purpose Discovery',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isProcessingAI.value) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B3A61),
                    Color(0xFF1E4E84),
                    Color(0xFF1A3150),
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF1EAEDB)),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing your journey...',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.aiResponse.value == null) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B3A61),
                    Color(0xFF1E4E84),
                    Color(0xFF1A3150),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'No response available',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B3A61),
                  Color(0xFF1E4E84),
                  Color(0xFF1A3150),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A4A7A), Color(0xFF1E3A5F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF1EAEDB).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1EAEDB).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF1EAEDB),
                          size: 48,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Your Purpose Discovery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Based on your spiritual journey reflections',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // AI Response
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      controller.aiResponse.value!.response,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Column(
                    children: [
                      // Primary action buttons
                      Row(
                        children: [
                          Expanded(
                            child: GradientActionButton(
                              text: 'Back to Journey',
                              onPressed: () => Get.back(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GradientActionButton(
                              text: 'Share',
                              onPressed: () {
                                Get.snackbar(
                                  'Share',
                                  'Share functionality coming soon!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xFF1EAEDB),
                                  colorText: Colors.white,
                                );
                              },
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Begin new journey button
                      SizedBox(
                        width: double.infinity,
                        child: GradientActionButton(
                          text: 'Begin Journey Again',
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // Reset journey and go back to dashboard
                            controller.resetJourneyWithResponse();
                            Get.back();
                            Get.snackbar(
                              'Journey Reset',
                              'You can now begin a new spiritual journey!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF1EAEDB),
                              colorText: Colors.white,
                            );
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
