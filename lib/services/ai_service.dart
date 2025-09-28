import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:sabeelapp/data/models/ai_response_model.dart';
import 'package:sabeelapp/services/api_service.dart';

class AIService {
  // Cache for responses
  final Map<String, AIResponse> _responseCache = {};

  /// Send a prompt to the AI service and get a response
  Future<AIResponse> sendPrompt(
    String prompt,
    Map<String, dynamic> context,
  ) async {
    // Create a cache key based on prompt and context
    final cacheKey = _generateCacheKey(prompt, context);

    // Check cache first
    if (_responseCache.containsKey(cacheKey)) {
      return _responseCache[cacheKey]!;
    }

    try {
      // Extract journey data from context
      final journeyData = _extractJourneyData(context);

      // Call Node.js API
      final response = await _callNodeApi(journeyData);

      // Cache the response
      _responseCache[cacheKey] = response;

      return response;
    } catch (e) {
      // Fallback to dummy response if API fails
      print('Node.js API failed, using fallback: $e');
      return _generateFallbackResponse(prompt, context);
    }
  }

  /// Call the Node.js API with journey data
  Future<AIResponse> _callNodeApi(Map<String, String> journeyData) async {
    try {
      final response = await ApiService.getAIInsight(
        userInputSelfReflection:
            journeyData['user_input_self_reflection'] ?? '',
        userInputDivineSigns: journeyData['user_input_divine_signs'] ?? '',
        userInputTalents: journeyData['user_input_talents'] ?? '',
        userInputService: journeyData['user_input_service'] ?? '',
      );

      if (response['success'] == true && response['data'] != null) {
        final insight = response['data']['insight'] as String;
        final interactionId = response['data']['interactionId'] as String?;
        final timestamp = response['data']['timestamp'] as String?;

        return AIResponse(
          id: interactionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
          prompt: 'purpose_discovery',
          response: insight,
          type: 'purpose_insight',
          timestamp: timestamp != null
              ? DateTime.parse(timestamp)
              : DateTime.now(),
          metadata: {
            'source': 'node_api',
            'user_id': journeyData['userId'] ?? 'anonymous',
            'step_type': 'purpose_discovery',
          },
        );
      } else {
        throw Exception('Invalid response format from Node.js API');
      }
    } catch (e) {
      print('Node.js API call failed: $e');
      rethrow;
    }
  }

  /// Extract journey data from context for Firebase function
  Map<String, String> _extractJourneyData(Map<String, dynamic> context) {
    // Get answers from the dashboard controller
    final answers = context['answers'] as Map<String, String>? ?? {};

    // Extract data for each section
    final selfReflection = _getSectionData(
      answers,
      0,
    ); // Step 0: Self-Reflection
    final divineSigns = _getSectionData(answers, 1); // Step 1: Divine Signs
    final talents = _getSectionData(answers, 2); // Step 2: Talents
    final service = _getSectionData(answers, 3); // Step 3: Service

    return {
      'user_input_self_reflection': selfReflection,
      'user_input_divine_signs': divineSigns,
      'user_input_talents': talents,
      'user_input_service': service,
      'userId': context['user_id'] ?? 'anonymous',
    };
  }

  /// Get combined data for a specific section
  String _getSectionData(Map<String, String> answers, int stepIndex) {
    final sectionAnswers = <String>[];

    // Collect all answers for this section (sub-steps)
    for (int subStep = 0; subStep < 5; subStep++) {
      // Assuming max 5 sub-steps per section
      final key = '${stepIndex}_$subStep';
      final answer = answers[key];
      if (answer != null && answer.trim().isNotEmpty) {
        sectionAnswers.add(answer.trim());
      }
    }

    return sectionAnswers.join('\n\n');
  }

  /// Generate fallback response when Firebase is unavailable
  AIResponse _generateFallbackResponse(
    String prompt,
    Map<String, dynamic> context,
  ) {
    final random = Random();
    final fallbackResponses = [
      "Your reflections show a deep spiritual awareness and a genuine desire to understand your purpose. Continue to trust in this process of self-discovery and remain open to the guidance that comes through prayer and reflection.",
      "The patterns in your journey suggest a calling toward service and helping others. Your natural talents combined with your spiritual sensitivity point toward a meaningful purpose in supporting others on their path.",
      "Your experiences with divine guidance and your natural abilities create a powerful foundation for your life's work. Trust in these gifts and continue to develop them in service to others.",
    ];

    final selectedResponse =
        fallbackResponses[random.nextInt(fallbackResponses.length)];

    return AIResponse(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prompt: prompt,
      response: selectedResponse,
      type: 'fallback_insight',
      timestamp: DateTime.now(),
      metadata: {
        'source': 'fallback',
        'user_id': context['user_id'] ?? 'anonymous',
        'step_type': context['step_type'] ?? 'general',
      },
    );
  }

  /// Get cached response if available
  AIResponse? getCachedResponse(String promptId) {
    return _responseCache[promptId];
  }

  /// Clear cache
  void clearCache() {
    _responseCache.clear();
  }

  /// Generate a cache key for the prompt and context
  String _generateCacheKey(String prompt, Map<String, dynamic> context) {
    final contextString = context.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
    return '${prompt.hashCode}_$contextString';
  }

  /// Get insights based on user's journey progress
  Future<AIResponse> getJourneyInsight(Map<String, dynamic> journeyData) async {
    try {
      // Use the same Node.js API for journey insights
      final answers = journeyData['answers'] as Map<String, String>? ?? {};

      final requestData = {
        'user_input_self_reflection': _getSectionData(answers, 0),
        'user_input_divine_signs': _getSectionData(answers, 1),
        'user_input_talents': _getSectionData(answers, 2),
        'user_input_service': _getSectionData(answers, 3),
        'userId': 'journey_insight_${DateTime.now().millisecondsSinceEpoch}',
      };

      return await _callNodeApi(requestData);
    } catch (e) {
      return _generateFallbackResponse('journey_insight', journeyData);
    }
  }
}
