import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/potato.dart';
import '../widgets/farm_plot.dart';
import '../services/sound_service.dart';

class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.shade50,
              Colors.green.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ヘッダー
              _buildHeader(context),
              const SizedBox(height: 16),
              // 畑のグリッド
              Expanded(
                child: _buildFarmGrid(context),
              ),
              // 統計情報
              _buildStats(context),
              const SizedBox(height: 8),
              // ヒントメッセージ
              _buildHintMessage(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          gameState.username ?? "未ログイン",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.daysPassed}日目',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    icon: const Icon(Icons.settings),
                    tooltip: '設定',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/warehouse');
                    },
                    icon: const Icon(Icons.warehouse),
                    label: const Text('倉庫へ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFarmGrid(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: GameState.totalPlots,
            itemBuilder: (context, index) {
              final potato = gameState.farm[index];
              return FarmPlot(
                potato: potato,
                onTap: () {
                  if (potato == null || potato.isEmpty) {
                    // 空の畑をクリック → 芋を植える
                    gameState.plantPotato(index);
                    SoundService().playPlantSound();
                  } else if (potato.isHarvestable) {
                    // 成熟した芋をクリック → 収穫
                    gameState.harvestPotato(index);
                    SoundService().playHarvestSound();
                    _checkAchievements(context, gameState);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHintMessage(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        String hintText;
        IconData hintIcon;
        Color hintColor;
        
        if (gameState.matureCount > 0) {
          hintText = '💬 ${gameState.matureCount}個の成熟した芋が収穫できます！';
          hintIcon = Icons.emoji_food_beverage;
          hintColor = Colors.orange;
        } else if (gameState.currentlyPlanted > 0) {
          hintText = '💬 芋が成長中です。しばらくお待ちください...';
          hintIcon = Icons.eco;
          hintColor = Colors.green;
        } else {
          hintText = '💬 空いている畑をタップして芋を植えましょう！';
          hintIcon = Icons.info_outline;
          hintColor = Colors.green;
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hintColor.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Icon(hintIcon, color: hintColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.agriculture,
                '植えた数',
                '${gameState.totalPlanted}',
                Colors.green,
              ),
              _buildStatItem(
                Icons.warehouse,
                '収穫数',
                '${gameState.totalHarvested}',
                Colors.orange,
              ),
              _buildStatItem(
                Icons.trending_up,
                '収穫率',
                '${gameState.harvestRate.toStringAsFixed(1)}%',
                Colors.blue,
              ),
              _buildStatItem(
                Icons.eco,
                '成熟中',
                '${gameState.matureCount}',
                Colors.orange.shade700,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }


  void _checkAchievements(BuildContext context, GameState gameState) {
    final achievements = <String>[];
    
    if (gameState.totalHarvested == 10) {
      achievements.add('初級農家: 10個収穫達成！');
    } else if (gameState.totalHarvested == 50) {
      achievements.add('中級農家: 50個収穫達成！');
    } else if (gameState.totalHarvested == 100) {
      achievements.add('上級農家: 100個収穫達成！');
    } else if (gameState.totalHarvested == 500) {
      achievements.add('マスター農家: 500個収穫達成！');
    }
    
    if (gameState.harvestRate >= 90.0 && gameState.totalPlanted >= 20) {
      achievements.add('完璧主義者: 収穫率90%以上達成！');
    }
    
    if (gameState.daysPassed >= 7) {
      achievements.add('継続の力: 7日間プレイ達成！');
    }
    
    for (final achievement in achievements) {
      SoundService().playAchievementSound();
      // 達成通知は音声のみで、バナーは表示しない
    }
  }
}

