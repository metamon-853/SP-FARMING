import 'package:flutter/material.dart';
import '../models/potato.dart';

class FarmPlot extends StatefulWidget {
  final Potato? potato;
  final VoidCallback onTap;

  const FarmPlot({
    super.key,
    required this.potato,
    required this.onTap,
  });

  @override
  State<FarmPlot> createState() => _FarmPlotState();
}

class _FarmPlotState extends State<FarmPlot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isAnimating) {
      setState(() => _isAnimating = true);
      _animationController.forward().then((_) {
        _animationController.reverse().then((_) {
          setState(() => _isAnimating = false);
        });
      });
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.brown.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.potato?.isHarvestable == true
                  ? Colors.orange.shade400
                  : Colors.brown.shade300,
              width: widget.potato?.isHarvestable == true ? 3 : 2,
            ),
            boxShadow: widget.potato?.isHarvestable == true
                ? [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.potato == null || widget.potato!.isEmpty) {
      // 空の畑
      return const Center(
        child: Icon(
          Icons.crop_free,
          color: Colors.brown,
          size: 30,
        ),
      );
    }

    final progress = widget.potato!.getGrowthProgress(DateTime.now());

    // 成長段階に応じた表示
    switch (widget.potato!.stage) {
      case PotatoStage.sprout:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: const Icon(
                    Icons.eco,
                    color: Colors.green,
                    size: 30,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            const Text(
              '芽',
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            _buildProgressBar(progress, Colors.green),
          ],
        );
      case PotatoStage.young:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: const Icon(
                    Icons.local_florist,
                    color: Colors.lightGreen,
                    size: 30,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            const Text(
              '若葉',
              style: TextStyle(
                fontSize: 10,
                color: Colors.lightGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            _buildProgressBar(progress, Colors.lightGreen),
          ],
        );
      case PotatoStage.mature:
        return Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (value * 0.1),
                    child: Transform.rotate(
                      angle: (value - 0.5) * 0.1,
                      child: const Icon(
                        Icons.emoji_food_beverage,
                        color: Colors.orange,
                        size: 35,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              const Text(
                '成熟',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              _buildProgressBar(1.0, Colors.orange),
            ],
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

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey.shade300,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
        ),
      ),
    );
  }
}

