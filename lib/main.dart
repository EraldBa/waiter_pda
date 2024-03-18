import 'package:flutter/material.dart';
import 'package:waiter_pda/app/app.dart';
import 'package:waiter_pda/services/hive_helper.dart';

Future<void> main() async {
  await HiveHelper.initHive();

  runApp(const App());
}
