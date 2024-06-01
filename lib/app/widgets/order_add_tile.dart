import 'package:flutter/material.dart';
import 'package:waiter_pda/app/widgets/quantity_adjustment_box.dart';
import 'package:waiter_pda/helpers/show.dart' as show;
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

class OrderAddTile extends StatefulWidget {
  final MenuItem menuItem;
  final Order order;

  const OrderAddTile({super.key, required this.menuItem, required this.order});

  @override
  State<OrderAddTile> createState() => _OrderAddTileState();
}

class _OrderAddTileState extends State<OrderAddTile> {
  late OrderItem _orderItem = OrderItem(menuItem: widget.menuItem);

  void _addOrder() {
    setState(() {
      widget.order.items.add(_orderItem);
      _orderItem = OrderItem(menuItem: widget.menuItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item (${_orderItem.menuItem.name}) has been added'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addOrderWithOptions() {
    show.addWithOptionsDialog(context, orderItem: _orderItem).then((confirmed) {
      if (confirmed) {
        _addOrder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(widget.menuItem.itemType.icon),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            QuantityAdjustmentBox(orderItem: _orderItem),
            TextButton(
              onPressed: _addOrder,
              onLongPress: _addOrderWithOptions,
              child: const Text('Add'),
            ),
          ],
        ),
        title: Text(widget.menuItem.name),
        subtitle: Text(
          '${widget.menuItem.priceFmt}${widget.menuItem.ingredientsFmt}',
        ),
        isThreeLine: widget.menuItem.ingredients != null,
      ),
    );
  }
}
