import 'package:flutter/material.dart';
import '../models/potato.dart';

class FarmPlot extends StatelessWidget {
  final Potato? potato;
  final VoidCallback onTap;

  const FarmPlot({
    super.key,
    required this.potato,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.brown.shade300,
            width: 2,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (potato == null || potato!.isEmpty) {
      // 空の畑
      return const Center(
        child: Icon(
          Icons.crop_free,
          color: Colors.brown,
          size: 30,
        ),
      );
    }

    // 成長段階に応じた表示
    switch (potato!.stage) {
      case PotatoStage.sprout:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco,
                color: Colors.green,
                size: 30,
              ),
              SizedBox(height: 4),
              Text(
                '芽',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case PotatoStage.young:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_florist,
                color: Colors.lightGreen,
                size: 30,
              ),
              SizedBox(height: 4),
              Text(
                '若葉',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case PotatoStage.mature:
        return Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_food_beverage,
                  color: Colors.orange,
                  size: 35,
                ),
                SizedBox(height: 4),
                Text(
                  '成熟',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      case PotatoStage.empty:
        return const Center(
          child: Icon(
            Icons.crop_free,
            color: Colors.brown,
            size: 30,
          ),
        );
    }
  }
}

