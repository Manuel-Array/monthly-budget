import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/models/item.dart';
import 'package:monthly_budget/models/item_adapter.dart';
import 'package:monthly_budget/pages/main_shell_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox<Item>('expenses');
  await Hive.openBox<Item>('incomes');
  await Hive.openBox('settings');

  await AppState.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: AppState.instance,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Budget',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const MainShellPage(),
      ),
    );
  }
}
