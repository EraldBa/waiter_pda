import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:waiter_pda/app/pages/home_page.dart';
import 'package:waiter_pda/app/pages/new_order_page.dart';
import 'package:waiter_pda/models/order.dart';

final class App extends StatelessWidget {
  static const Color appColor = Colors.lightBlueAccent;

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiter PDA',
      theme: ThemeData(
        fontFamily: 'Product Sans',
        snackBarTheme: const SnackBarThemeData(backgroundColor: appColor),
        brightness:
            SchedulerBinding.instance.platformDispatcher.platformBrightness,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: appColor.withOpacity(0.15),
        ),
        colorSchemeSeed: appColor,
        useMaterial3: true,
      ),
      routes: {
        HomePage.route: (context) => const HomePage(),
        NewOrderPage.route: (context) => NewOrderPage(order: Order(items: [])),
      },
    );
  }
}
