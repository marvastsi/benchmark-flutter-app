import 'package:benchmark_flutter_app/src/modules/config/config_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Benchmark',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AppConfigPage(),
    );
  }
}
