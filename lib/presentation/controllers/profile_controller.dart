import 'package:get/get.dart';
import 'package:sabeelapp/services/api_service.dart';
import 'package:sabeelapp/data/models/ai_response_model.dart';

class ProfileController extends GetxController {
  // Observable variables
  var aiHistory = <AIResponse>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var totalInteractions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAIHistory();
  }

  /// Load AI interaction history from server
  Future<void> loadAIHistory({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      aiHistory.clear();
      hasMoreData.value = true;
    }

    if (!hasMoreData.value && !refresh) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.getAIHistory(
        page: currentPage.value,
        limit: 10,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final interactions = data['interactions'] as List<dynamic>;
        final pagination = data['pagination'] as Map<String, dynamic>;

        // Convert server data to AIResponse objects
        final newResponses = interactions.map((interaction) {
          return AIResponse(
            id:
                interaction['_id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            prompt: 'purpose_discovery',
            response: interaction['aiResponse'] ?? '',
            type: 'purpose_insight',
            timestamp: interaction['timestamp'] != null
                ? DateTime.parse(interaction['timestamp'])
                : DateTime.now(),
            metadata: {
              'source': 'server_history',
              'interaction_id': interaction['_id'],
              'step_type': 'purpose_discovery',
            },
          );
        }).toList();

        if (refresh) {
          aiHistory.value = newResponses;
        } else {
          aiHistory.addAll(newResponses);
        }

        // Update pagination info
        totalInteractions.value = pagination['totalInteractions'] ?? 0;
        hasMoreData.value = pagination['hasNextPage'] ?? false;

        if (hasMoreData.value) {
          currentPage.value++;
        }

        print('Loaded ${newResponses.length} AI responses from history');
      } else {
        throw Exception('Failed to load AI history');
      }
    } catch (e) {
      print('Error loading AI history: $e');
      errorMessage.value = 'Failed to load response history. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh the history
  Future<void> refreshHistory() async {
    await loadAIHistory(refresh: true);
  }

  /// Load more history (pagination)
  Future<void> loadMoreHistory() async {
    if (!isLoading.value && hasMoreData.value) {
      await loadAIHistory();
    }
  }

  /// Clear all history
  void clearHistory() {
    aiHistory.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    totalInteractions.value = 0;
  }

  /// Get formatted date string
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Get formatted time string
  String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
