import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waiter_pda/app/widgets/order_with_options_dialog.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

final dateFmt = DateFormat('dd/MM/yyyy kk:mm');

Future<bool> alertDialog(
  BuildContext context, {
  required String title,
  String? message,
}) async {
  final confirmation = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          )
        ],
      );
    },
  );

  return confirmation == true;
}

Future<bool> addWithOptionsDialog(
  BuildContext context, {
  required OrderItem orderItem,
}) async {
  final confirmation = await showDialog<bool>(
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

Future<void> orderInfoDialog(
  BuildContext context,
  Order order,
) async {
  final contentList = <String>[
    'Table:  ${order.tableName}',
    'Items:  ${order.itemCount}',
    'Total:  ${order.totalAsEuro}',
    'Status:  ${!order.isInBox ? 'Not saved' : order.completed ? 'Completed' : 'Pending'}',
    'Date created:   ${dateFmt.format(order.createdAt)}',
    'Date modified:  ${dateFmt.format(order.updatedAt)}',
  ];

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.info),
        title: const Text('Order Info'),
        content: FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentList.map((c) {
              return Text(
                c,
                style: const TextStyle(fontSize: 25.0),
              );
            }).toList(),
          ),
        ),
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
