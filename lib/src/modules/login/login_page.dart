import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/login/login_client.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:benchmark_flutter_app/src/modules/model/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.config});

  final Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('login_page'),
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 40, right: 30, left: 30),
        child:
            SingleChildScrollView(child: LoginForm(baseUrl: config.serverUrl)),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.baseUrl});

  final String baseUrl;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<Token>? _futureResponse;
  late Function(BuildContext) btnPressed;

  @override
  void initState() {
    setState(() {
      _usernameController.text = 'greenbenchmark';
      _passwordController.text = 'greenbenchmark';

      btnPressed = (ctx) {
        setState(() {
          _futureResponse = LoginClient(baseUrl: widget.baseUrl).login(
              Credentials(
                  username: _usernameController.text,
                  password: _passwordController.text));
        });

        // sleep(const Duration(seconds: 2));
        _showSuccessMessage();
        Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => btnPressed(context));

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                labelText: 'Username',
                hintText: 'Username',
              ),
              controller: _usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
              ),
              controller: _passwordController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 100, right: 50),
            child: ValueListenableBuilder<bool>(
                valueListenable: formValidVN,
                builder: (_, formValid, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !formValid ? null : btnPressed(context),
                      child: const Text('Login'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: _buildFutureBuilder()),
    );
  }

  FutureBuilder<Token> _buildFutureBuilder() {
    return FutureBuilder<Token>(
      future: _futureResponse,
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
