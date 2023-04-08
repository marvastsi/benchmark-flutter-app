import 'package:benchmark_flutter_app/home_page.dart';
import 'package:benchmark_flutter_app/src/commons/config_storage.dart';
import 'package:benchmark_flutter_app/src/modules/account/account_client.dart';
import 'package:benchmark_flutter_app/src/modules/execution/execution_page.dart';
import 'package:benchmark_flutter_app/src/modules/http/http_exception.dart';
import 'package:benchmark_flutter_app/src/modules/model/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        child: const SingleChildScrollView(child: AccountForm()),
      ),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

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

  Future<Account>? _futureResponse;
  CountryCodeEntry? selectedCode = CountryCodeEntry.none;
  final ConfigStorage _configStorage = ConfigStorage();
  bool active = false;
  bool notifications = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _phoneCountryCodeController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                if (value == null || value.isEmpty) {
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
                    onSelected: (CountryCodeEntry? scenario) {
                      setState(() {
                        selectedCode = scenario;
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4.0),
          //   child: SwitchListTile(
          //       contentPadding: EdgeInsets.zero, //switch at right side of label
          //       value: active,
          //       onChanged: (bool value) {
          //         setState(() {
          //           active = value;
          //         });
          //       },
          //       title: const Text("Active")),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4.0),
          //   child: CheckboxListTile(
          //     contentPadding: EdgeInsets.zero,
          //     title: const Text('Notifications'),
          //     value: notifications,
          //     onChanged: (bool? value) {
          //       setState(() {
          //         notifications = value!;
          //       });
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: <Widget>[
                const Expanded(flex: 0, child: Text('Active')),
                Switch(
                  //switch at right side of label
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
                  return 'Username is required';
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
                              _futureResponse = saveAccount(Account(
                                null,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                phoneNumber: _phoneNumberController.text,
                                phoneCountryCode: selectedCode!.code,
                                email: _emailController.text,
                                active: false,
                                notification: false,
                                username: _usernameController.text,
                                password: _passwordController.text,
                              ));

                              // sleep(const Duration(seconds: 2));

                              showSuccessMessage();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: navigate(context, 1)),
                              );
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

  void showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: buildFutureBuilder()),
    );
  }

  FutureBuilder<Account> buildFutureBuilder() {
    return FutureBuilder<Account>(
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

  WidgetBuilder navigate(BuildContext context, int page) {
    if (page == 1) {
      return (context) => const HomePage();
    }
    throw Exception('No routes found');
  }
}

enum CountryCodeEntry {
  none('Select'),
  brazil('+55'),
  usa('+1');

  const CountryCodeEntry(this.code);

  final String code;
}
