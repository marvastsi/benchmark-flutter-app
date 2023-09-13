import 'package:flutter/material.dart';

List<Widget> appBarActions(BuildContext context) {
  return <Widget>[
    IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Implement this')));
      },
    ),
  ];
}
