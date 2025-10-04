import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabeelapp/presentation/controllers/profile_controller.dart';
import 'package:sabeelapp/presentation/widgets/gradient_action_button.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
          'Response History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshHistory(),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B3A61), Color(0xFF1E4E84), Color(0xFF1A3150)],
            ),
          ),
          child: Obx(() {
            if (controller.isLoading.value && controller.aiHistory.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF1EAEDB)),
                    SizedBox(height: 16),
                    Text(
                      'Loading your response history...',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    GradientActionButton(
                      text: 'Try Again',
                      onPressed: () => controller.refreshHistory(),
                    ),
                  ],
                ),
              );
            }

            if (controller.aiHistory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history,
                      color: Color(0xFF1EAEDB),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Response History',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete your first spiritual journey to see your AI responses here.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    GradientActionButton(
                      text: 'Start Journey',
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Header with total count
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.history,
                        color: Color(0xFF1EAEDB),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${controller.totalInteractions.value} Response${controller.totalInteractions.value != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Your spiritual journey insights',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // History list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.refreshHistory(),
                    color: const Color(0xFF1EAEDB),
                    backgroundColor: const Color(0xFF1B3A61),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount:
                          controller.aiHistory.length +
                          (controller.hasMoreData.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.aiHistory.length) {
                          // Load more indicator
                          if (controller.isLoading.value) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1EAEDB),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: TextButton(
                                  onPressed: () => controller.loadMoreHistory(),
                                  child: const Text(
                                    'Load More',
                                    style: TextStyle(color: Color(0xFF1EAEDB)),
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        final response = controller.aiHistory[index];
                        return _buildHistoryItem(response, index);
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(dynamic response, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF1EAEDB),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Response #${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.formatDate(response.timestamp),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    controller.formatTime(response.timestamp),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Response content
          Text(
            response.response,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // View full response button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showFullResponse(response),
              child: const Text(
                'View Full Response',
                style: TextStyle(
                  color: Color(0xFF1EAEDB),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullResponse(dynamic response) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
            maxWidth: MediaQuery.of(Get.context!).size.width * 0.9,
          ),
          child: Container(
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
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Full Response',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date and time
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF1EAEDB),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.formatDate(response.timestamp)} at ${controller.formatTime(response.timestamp)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Full response content with scrolling
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        response.response,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: GradientActionButton(
                    text: 'Close',
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
