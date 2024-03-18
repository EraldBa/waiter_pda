import 'package:flutter/material.dart';
import 'package:waiter_pda/app/widgets/my_alert_dialog.dart';
import 'package:waiter_pda/app/widgets/order_with_options_dialog.dart';
import 'package:waiter_pda/models/order_item.dart';

Future<bool> alertDialog(
  BuildContext context, {
  required String title,
  String? message,
}) async {
  final confirmation = await showDialog<bool>(
    context: context,
    builder: (context) {
      return MyAlertDialog(
        title: title,
        message: message,
      );
    },
  );

  return confirmation == true;
}

Future<bool> addWithOptionsDialog(
  BuildContext context, {
  required OrderItem orderItem,
}) async {
  final confirmation = await showDialog(
    context: context,
    builder: (context) {
      return OrderOptionsDialog(orderItem);
    },
  );

  return confirmation == true;
}

Future<void> warningDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.warning_rounded),
        title: Text(message),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
