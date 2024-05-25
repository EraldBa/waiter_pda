import 'package:flutter/material.dart';
import 'package:waiter_pda/app/pages/order_details_page.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;
import 'package:waiter_pda/models/order.dart';

class SlidableOrder extends StatelessWidget {
  final Order order;
  final void Function(VoidCallback) setParentState;

  const SlidableOrder({
    required super.key,
    required this.order,
    required this.setParentState,
  });

  void _completeOrder() {
    setParentState(() {
      order.completed = true;
      order.save();
    });
  }

  void _deleteOrder() {
    setParentState(() {
      order.delete();
    });
  }

  void _restoreOrder(BuildContext context) {
    setParentState(() {
      if (HiveHelper.tableExistsInPending(order.tableName)) {
        show.warningDialog(context, 'Table already exists in pending orders!');
      } else {
        order.completed = false;
        order.save();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ),
      secondaryBackground: order.completed
          ? Container(
              alignment: Alignment.centerRight,
              color: Colors.green,
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.restore_from_trash),
              ),
            )
          : Container(
              alignment: Alignment.centerRight,
              color: Theme.of(context).colorScheme.inversePrimary,
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.done),
              ),
            ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _deleteOrder();
        } else if (direction == DismissDirection.endToStart) {
          if (order.completed) {
            _restoreOrder(context);
          } else {
            _completeOrder();
          }
        }
      },
      child: ListTile(
        leading: const Icon(
          Icons.table_bar_outlined,
          size: 40,
        ),
        trailing: order.completed ? const Icon(Icons.check) : null,
        title: Text('Table: ${order.tableName}'),
        subtitle: Text('Total: ${order.totalAsEuro}'),
        onTap: order.notCompleted
            ? () {
                Navigator.of(context).push(
                  OrderDetailsPage.customRoute(context, order: order),
                );
              }
            : null,
        onLongPress: () {
          show.orderInfo(context, order);
        },
      ),
    );
  }
}
