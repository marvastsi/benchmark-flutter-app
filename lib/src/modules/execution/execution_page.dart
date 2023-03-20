import 'package:benchmark_flutter_app/home_page.dart';
import 'package:flutter/material.dart';

class ExecutionPage extends StatelessWidget {
  const ExecutionPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Benchmark'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: const SingleChildScrollView(child: ExecutionForm()),
      ),
    );
  }
}

class ExecutionForm extends StatefulWidget {
  const ExecutionForm({super.key});

  @override
  State<ExecutionForm> createState() => _ExecutionFormState();
}

class _ExecutionFormState extends State<ExecutionForm> {
  int _scenario = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Text('Click the button to Start'),
          ),
        ),
        const SizedBox(
          height: 200,
        ),
        Center(
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _scenario = 1;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: navigate(context, _scenario)),
                );
              },
              child: const Text('Start'),
            ),
          ),
        ),
      ],
    );
  }

  WidgetBuilder navigate(BuildContext context, int page) {
    if (page == 1) {
      return (context) => const HomePage();
    }
    throw Exception('No routes found');
  }
}
