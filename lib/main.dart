import 'package:MoneyManager/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MoneyManager(),
    ),
  );
}

class MoneyManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
