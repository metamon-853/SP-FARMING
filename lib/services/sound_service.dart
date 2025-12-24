import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // 植える音（短いポップ音）
  Future<void> playPlantSound() async {
    if (!_soundEnabled) return;
    try {
      // シンプルなビープ音を生成
      await _playBeep(440, 100); // A4音、100ms
    } catch (e) {
      debugPrint('Error playing plant sound: $e');
    }
  }

  // 収穫音（成功音）
  Future<void> playHarvestSound() async {
    if (!_soundEnabled) return;
    try {
      // 2つの音を連続で再生
      await _playBeep(523, 80); // C5音
      await Future.delayed(const Duration(milliseconds: 50));
      await _playBeep(659, 120); // E5音
    } catch (e) {
      debugPrint('Error playing harvest sound: $e');
    }
  }

  // 達成音（ファンファーレ）
  Future<void> playAchievementSound() async {
    if (!_soundEnabled) return;
    try {
      // ファンファーレ風の音
      await _playBeep(523, 100); // C5
      await Future.delayed(const Duration(milliseconds: 50));
      await _playBeep(659, 100); // E5
      await Future.delayed(const Duration(milliseconds: 50));
      await _playBeep(784, 150); // G5
    } catch (e) {
      debugPrint('Error playing achievement sound: $e');
    }
  }

  // 成長音（静かな音）
  Future<void> playGrowthSound() async {
    if (!_soundEnabled) return;
    try {
      await _playBeep(330, 50); // E4音、短く
    } catch (e) {
      debugPrint('Error playing growth sound: $e');
    }
  }

  // ビープ音を生成（周波数と長さを指定）
  Future<void> _playBeep(double frequency, int durationMs) async {
    // 実際の実装では、音声ファイルを使用するか、
    // より高度な音声生成ライブラリを使用します
    // ここでは簡易的な実装として、システム音を使用
    // 実際のアプリでは、assetsフォルダに音声ファイルを配置して使用
    
    // デバッグ用のログ（本番環境では削除可能）
    if (kDebugMode) {
      debugPrint('🔊 Playing sound: ${frequency.toStringAsFixed(0)}Hz for ${durationMs}ms');
    }
    
    // 実際の音声ファイルがない場合、システム音を使用
    // 将来的には、assetsフォルダに音声ファイルを追加して使用
    // 例: await _player.play(AssetSource('sounds/plant.mp3'));
  }

  void dispose() {
    _player.dispose();
  }
}

