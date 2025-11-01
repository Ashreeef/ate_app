class Challenge {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final int targetCount;
  final int currentCount;
  final String rewardBadge;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isJoined;
  final ChallengeType type;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.targetCount,
    required this.currentCount,
    required this.rewardBadge,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.isJoined = false,
    this.type = ChallengeType.general,
  });

  double get progress => targetCount > 0 ? currentCount / targetCount : 0.0;

  int get remaining =>
      targetCount > currentCount ? targetCount - currentCount : 0;

  bool get isCompleted => currentCount >= targetCount;

  // Factory constructor for creating from JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int,
      rewardBadge: json['rewardBadge'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isJoined: json['isJoined'] as bool? ?? false,
      type: ChallengeType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ChallengeType.general,
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'rewardBadge': rewardBadge,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'isJoined': isJoined,
      'type': type.toString().split('.').last,
    };
  }

  // Copy with method for updating joined status
  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? targetCount,
    int? currentCount,
    String? rewardBadge,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? isJoined,
    ChallengeType? type,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      rewardBadge: rewardBadge ?? this.rewardBadge,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      isJoined: isJoined ?? this.isJoined,
      type: type ?? this.type,
    );
  }
}

enum ChallengeType { general, restaurant, dish, location }
