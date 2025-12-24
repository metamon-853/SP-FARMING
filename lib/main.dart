import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/farm_screen.dart';
import 'screens/warehouse_screen.dart';
import 'models/game_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'SP-FARMING',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        routes: {
          '/farm': (context) => const FarmScreen(),
          '/warehouse': (context) => const WarehouseScreen(),
        },
      ),
    );
  }
}

