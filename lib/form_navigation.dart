import 'dart:io';

import 'package:benchmark_flutter_app/home_page.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/login/login_client.dart';
import 'package:benchmark_flutter_app/src/modules/model/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Login';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 60.0),
          child: const MyCustomForm(),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<Token>? _futureToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      onChanged: () {
        formValidVN.value = _formKey.currentState?.validate() ?? false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Not a valid username';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Username',
              ),
              controller: _emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.length <= 5) {
                  return 'Password must be >5 characters';
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Password',
              ),
              controller: _passwordController,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 100.0),
            child: ValueListenableBuilder<bool>(
                valueListenable: formValidVN,
                builder: (_, formValid, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !formValid
                          ? null
                          : () {
                              setState(() {
                                _futureToken = login(Credentials(
                                    username: _emailController.text,
                                    password: _passwordController.text));
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: buildFutureBuilder()),
                              );
                              sleep(const Duration(seconds: 2));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: navigate(context, 1)),
                              );
                            },
                      child: const Text('Login'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  WidgetBuilder navigate(BuildContext context, int page) {
    if (page == 1) {
      return (context) => const HomePage();
    }
    throw Exception('No routes found');
  }

  FutureBuilder<Token> buildFutureBuilder() {
    return FutureBuilder<Token>(
      future: _futureToken,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('${snapshot.data}');
        } else if (snapshot.hasError) {
          HttpException error = snapshot.error! as HttpException;
          return Text('${error.code}: ${error.message}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
