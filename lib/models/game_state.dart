import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'potato.dart';

class GameState extends ChangeNotifier {
  // 畑のサイズ: 3行 × 6列 = 18マス
  static const int rows = 3;
  static const int cols = 6;
  static const int totalPlots = rows * cols;

  List<Potato?> _farm = List.filled(totalPlots, null);
  int _warehouseCount = 0;
  String? _username;
  DateTime? _gameStartDate;
  int _daysPassed = 0;

  List<Potato?> get farm => _farm;
  int get warehouseCount => _warehouseCount;
  String? get username => _username;
  int get daysPassed => _daysPassed;

  bool get isLoggedIn => _username != null;

  GameState() {
    _initializeFarm();
    _loadGameData();
    _startGrowthTimer();
  }

  void _initializeFarm() {
    _farm = List.filled(totalPlots, null);
  }

  // 芋を植える（空の畑をクリック）
  void plantPotato(int index) {
    if (index < 0 || index >= totalPlots) return;
    if (_farm[index] != null && !_farm[index]!.isEmpty) return;

    final potato = Potato(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      stage: PotatoStage.sprout,
      plantedAt: DateTime.now(),
    );

    _farm[index] = potato;
    notifyListeners();
    _saveGameData();
  }

  // 芋を収穫する
  void harvestPotato(int index) {
    if (index < 0 || index >= totalPlots) return;
    final potato = _farm[index];
    if (potato == null || !potato.isHarvestable) return;

    _warehouseCount++;
    _farm[index] = null;
    notifyListeners();
    _saveGameData();
  }

  // 倉庫の芋を確認（個数は既にwarehouseCountで取得可能）

  // ログイン
  void login(String username) {
    _username = username;
    if (_gameStartDate == null) {
      _gameStartDate = DateTime.now();
      _daysPassed = 1;
    } else {
      _updateDaysPassed();
    }
    notifyListeners();
    _saveGameData();
  }

  // ログアウト
  void logout() {
    _username = null;
    notifyListeners();
    _saveGameData();
  }

  // 日数を更新
  void _updateDaysPassed() {
    if (_gameStartDate == null) return;
    final now = DateTime.now();
    final difference = now.difference(_gameStartDate!);
    _daysPassed = difference.inDays + 1;
  }

  // 成長タイマーを開始
  void _startGrowthTimer() {
    // 1秒ごとに成長をチェック
    Future.delayed(const Duration(seconds: 1), () {
      _checkGrowth();
      _startGrowthTimer();
    });
  }

  // 成長をチェック
  void _checkGrowth() {
    final now = DateTime.now();
    bool hasChanged = false;

    for (int i = 0; i < _farm.length; i++) {
      final potato = _farm[i];
      if (potato != null && !potato.isEmpty) {
        final oldStage = potato.stage;
        potato.checkGrowth(now);
        if (potato.stage != oldStage) {
          hasChanged = true;
        }
      }
    }

    if (hasChanged) {
      notifyListeners();
      _saveGameData();
    }
  }

  // ゲームデータを保存
  Future<void> _saveGameData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmData = _farm.map((p) => p?.toJson()).toList();
      await prefs.setString('farm', jsonEncode(farmData));
      await prefs.setInt('warehouseCount', _warehouseCount);
      if (_username != null) {
        await prefs.setString('username', _username!);
      }
      if (_gameStartDate != null) {
        await prefs.setString('gameStartDate', _gameStartDate!.toIso8601String());
      }
      await prefs.setInt('daysPassed', _daysPassed);
    } catch (e) {
      debugPrint('Error saving game data: $e');
    }
  }

  // ゲームデータを読み込み
  Future<void> _loadGameData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmDataStr = prefs.getString('farm');
      if (farmDataStr != null) {
        final farmData = jsonDecode(farmDataStr) as List;
        _farm = farmData.map((json) {
          if (json == null) return null;
          return Potato.fromJson(json as Map<String, dynamic>);
        }).toList();
      }

      _warehouseCount = prefs.getInt('warehouseCount') ?? 0;
      _username = prefs.getString('username');
      final gameStartDateStr = prefs.getString('gameStartDate');
      if (gameStartDateStr != null) {
        _gameStartDate = DateTime.parse(gameStartDateStr);
        _updateDaysPassed();
      }
      _daysPassed = prefs.getInt('daysPassed') ?? 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading game data: $e');
    }
  }

  // サーバーとの同期（将来の実装用）
  Future<void> syncWithServer() async {
    // TODO: AWS認証とデータ同期を実装
    debugPrint('Syncing with server...');
  }
}

