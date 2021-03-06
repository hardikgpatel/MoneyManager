import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/screens/add_transaction_screen.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:MoneyManager/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
