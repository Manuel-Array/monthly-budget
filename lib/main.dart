import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:monthly_budget/app_state.dart';
import 'package:monthly_budget/pages/home_page.dart';

void main() {
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
        home: const HomePage(),
      ),
    );
  }
}
