enum PotatoStage {
  empty,    // 空
  sprout,   // 芽
  young,    // 若葉
  mature,   // 成熟
}

class Potato {
  final String id;
  PotatoStage stage;
  final DateTime plantedAt;

  Potato({
    required this.id,
    required this.stage,
    required this.plantedAt,
  });

  // 収穫可能かどうか
  bool get isHarvestable => stage == PotatoStage.mature;

  // 空かどうか
  bool get isEmpty => stage == PotatoStage.empty;

  // 成長に必要な時間（秒）
  static const int sproutToYoungSeconds = 10; // 10秒で若葉へ
  static const int youngToMatureSeconds = 20; // さらに20秒で成熟へ

  // 現在の成長段階に応じた経過時間をチェック
  void checkGrowth(DateTime now) {
    if (stage == PotatoStage.empty) return;

    final elapsed = now.difference(plantedAt).inSeconds;

    if (stage == PotatoStage.sprout && elapsed >= sproutToYoungSeconds) {
      stage = PotatoStage.young;
    } else if (stage == PotatoStage.young && elapsed >= sproutToYoungSeconds + youngToMatureSeconds) {
      stage = PotatoStage.mature;
    }
  }
  
  // 成長進捗を0.0〜1.0で返す
  double getGrowthProgress(DateTime now) {
    if (stage == PotatoStage.empty) return 0.0;
    
    final elapsed = now.difference(plantedAt).inSeconds;
    
    if (stage == PotatoStage.sprout) {
      return (elapsed / sproutToYoungSeconds).clamp(0.0, 1.0);
    } else if (stage == PotatoStage.young) {
      final progress = (elapsed - sproutToYoungSeconds) / youngToMatureSeconds;
      return (0.5 + progress * 0.5).clamp(0.0, 1.0);
    } else if (stage == PotatoStage.mature) {
      return 1.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage': stage.name,
      'plantedAt': plantedAt.toIso8601String(),
    };
  }

  factory Potato.fromJson(Map<String, dynamic> json) {
    return Potato(
      id: json['id'] as String,
      stage: PotatoStage.values.firstWhere(
        (e) => e.name == json['stage'],
        orElse: () => PotatoStage.empty,
      ),
      plantedAt: DateTime.parse(json['plantedAt'] as String),
    );
  }
}

