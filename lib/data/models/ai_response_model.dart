class AIResponse {
  final String id;
  final String prompt;
  final String response;
  final String type; // 'reflection', 'guidance', 'insight', etc.
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  AIResponse({
    required this.id,
    required this.prompt,
    required this.response,
    required this.type,
    required this.timestamp,
    this.metadata = const {},
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      id: json['id'] ?? '',
      prompt: json['prompt'] ?? '',
      response: json['response'] ?? '',
      type: json['type'] ?? 'reflection',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'response': response,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  AIResponse copyWith({
    String? id,
    String? prompt,
    String? response,
    String? type,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AIResponse(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}
