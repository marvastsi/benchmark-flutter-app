import 'package:benchmark_flutter_app/home_page.dart';
import 'package:flutter/material.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: const SingleChildScrollView(child: MediaForm()),
      ),
    );
  }
}

class MediaForm extends StatefulWidget {
  const MediaForm({super.key});

  @override
  State<MediaForm> createState() => _MediaFormState();
}

class _MediaFormState extends State<MediaForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Text('Media File'),
        ),
      ],
    );
  }

  void showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Media Executed')),
    );
  }

  WidgetBuilder navigate(BuildContext context, int page) {
    if (page == 1) {
      return (context) => const HomePage();
    }
    throw Exception('No routes found');
  }
}
