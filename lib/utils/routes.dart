import 'package:MoneyManager/screens/add_transaction_screen.dart';
import 'package:MoneyManager/screens/home_screen.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        );

      case TransactionListScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return TransactionListScreen();
          },
        );

      case AddTransactionScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return AddTransactionScreen();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
        break;
    }
  }
}