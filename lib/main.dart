import 'package:benchmark_flutter_app/src/modules/media/media_player_page.dart';
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
      // home: const AppConfigPage(),
      home: const MediaPlayerPage(),
    );
  }
}

// try to reuse this
class MainPage extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const MainPage(
      {super.key,
      required this.title,
      required this.padding,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: padding ?? const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
