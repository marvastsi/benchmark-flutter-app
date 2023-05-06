import 'package:benchmark_flutter_app/src/commons/string_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/account/account_client.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/account.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.config});

  final Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('account_page'),
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        child: SingleChildScrollView(
            child: AccountForm(baseUrl: config.serverUrl)),
      ),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key, required this.baseUrl});

  final String baseUrl;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final formValidVN = ValueNotifier<bool>(false);
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneCountryCodeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<AccountCreated>? _futureResponse;
  CountryCodeEntry? selectedCode = CountryCodeEntry.none;
  bool active = false;
  bool notifications = false;
  late Function(BuildContext) btnPressed;

  @override
  void initState() {
    super.initState();

    setState(() {
      _firstNameController.text = 'Marcelo';
      _lastNameController.text = 'Vasconcelos';
      _phoneNumberController.text = '44900880099';
      selectedCode = CountryCodeEntry.brazil;
      _emailController.text = 'marvas@alunos.utfpr.edu.br';
      active = true;
      notifications = false;
      _usernameController.text = 'greenbenchmark';
      _passwordController.text = 'greenbenchmark';
      formValidVN.value = true;

      btnPressed = (ctx) {
        setState(() {
          var account = Account(
            null,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            phoneNumber: _phoneNumberController.text,
            phoneCountryCode: selectedCode!.code,
            email: _emailController.text,
            active: active,
            notification: notifications,
            username: _usernameController.text,
            password: _passwordController.text,
          );

          _futureResponse =
              AccountClient(baseUrl: widget.baseUrl).saveAccount(account);
        });

        _showSuccessMessage();

        Future.delayed(
            const Duration(seconds: 2), () => Navigator.pop(context));
      };

      WidgetsBinding.instance.addPostFrameCallback((_) => btnPressed(context));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _phoneCountryCodeController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<CountryCodeEntry>> scenarioEntries =
        <DropdownMenuEntry<CountryCodeEntry>>[];
    for (final CountryCodeEntry scenario in CountryCodeEntry.values) {
      scenarioEntries.add(DropdownMenuEntry<CountryCodeEntry>(
          value: scenario, label: scenario.code));
    }

    return Form(
      key: _formKey,
      onChanged: () {
        formValidVN.value = _formKey.currentState?.validate() ?? false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'First name required';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'First Name',
                hintText: 'First Name',
              ),
              controller: _firstNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'Last Name',
              ),
              controller: _lastNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.isValidEmail()) {
                  return 'Not a valid Email';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
              ),
              controller: _usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: DropdownMenu<CountryCodeEntry>(
                    inputDecorationTheme: const InputDecorationTheme(
                        border: UnderlineInputBorder()),
                    initialSelection: CountryCodeEntry.none,
                    controller: _phoneCountryCodeController,
                    dropdownMenuEntries: scenarioEntries,
                    onSelected: (CountryCodeEntry? code) {
                      setState(() {
                        selectedCode = code;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || int.parse(value) <= 10) {
                  return 'Not a valid phone number';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Phone Number',
              ),
              controller: _phoneNumberController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: <Widget>[
                const Expanded(flex: 0, child: Text('Active')),
                Switch(
                  value: active,
                  onChanged: (bool value) {
                    setState(() {
                      active = value;
                    });
                  },
                ),
                const Expanded(
                  flex: 2,
                  child: Text(''),
                ),
                Checkbox(
                  value: notifications,
                  onChanged: (bool? value) {
                    setState(() {
                      notifications = value!;
                    });
                  },
                ),
                const Expanded(flex: 0, child: Text('Notifications')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
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
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty || int.parse(value) <= 5) {
                  return 'Password must be >5 characters';
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
            padding: const EdgeInsets.only(top: 50, right: 40, left: 40),
            child: ValueListenableBuilder<bool>(
                valueListenable: formValidVN,
                builder: (_, formValid, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !formValid
                          ? null
                          : () {
                              btnPressed(context);
                            },
                      child: const Text('Save'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: _buildFutureBuilder()),
    );
  }

  FutureBuilder<AccountCreated> _buildFutureBuilder() {
    return FutureBuilder<AccountCreated>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('Account created with id: ${snapshot.data?.id}');
        } else if (snapshot.hasError) {
          HttpException error = snapshot.error! as HttpException;
          return Text('${error.code}: Account create failed');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

enum CountryCodeEntry {
  none('Select'),
  brazil('+55'),
  usa('+1');

  const CountryCodeEntry(this.code);

  final String code;
}
