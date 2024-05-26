import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waiter_pda/app/pages/new_order_page.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  final bool ordersAreSaved;

  const OrderDetailsPage({
    super.key,
    required this.order,
    this.ordersAreSaved = true,
  });

  static MaterialPageRoute customRoute(
    BuildContext context, {
    required Order order,
  }) {
    return MaterialPageRoute(
      builder: (context) => OrderDetailsPage(order: order),
    );
  }

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _scrollController = ScrollController();

  bool _isFABVisible = true;

  void _removeItem(OrderItem item) {
    show
        .alertDialog(
      context,
      title: 'Confirmation',
      message: 'Do you wish to remove item "${item.menuItem.name}" from order?',
    )
        .then((confirmed) {
      if (confirmed) {
        setState(() {
          widget.order.items.remove(item);

          if (widget.ordersAreSaved) {
            widget.order.save();
          }
        });
      }
    });
  }

  bool get _showFAB => widget.ordersAreSaved && _isFABVisible;

  void _editItem(OrderItem item) {
    show
        .addWithOptionsDialog(
      context,
      orderItem: item,
    )
        .then((confirmed) {
      setState(() {
        if (confirmed && widget.ordersAreSaved) {
          widget.order.save();
        }
      });
    });
  }

  void _submitTable(String value) {
    if (HiveHelper.tableExistsInPending(value)) {
      show.warningDialog(context, 'Table already exists in Pending!');
      return;
    }

    widget.order.tableName = value;
    widget.order.save();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      setState(() {
        if (direction == ScrollDirection.reverse) {
          _isFABVisible = false;
        } else if (direction == ScrollDirection.forward) {
          _isFABVisible = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Row(
            children: [
              const Text('Order details for table: '),
              TextFormField(
                initialValue: widget.order.tableName,
                onFieldSubmitted: _submitTable,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  constraints: BoxConstraints.expand(width: 50.0, height: 30.0),
                ),
              ),
              IconButton(
                onPressed: () => show.orderInfoDialog(context, widget.order),
                icon: const Icon(Icons.info),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: widget.order.items.length,
        itemBuilder: (context, index) {
          final item = widget.order.items[index];

          return Card(
            key: UniqueKey(),
            child: ListTile(
              leading: Icon(item.menuItem.itemType.icon),
              title: Text(item.menuItem.name),
              subtitle: Text(
                item.isCoffee
                    ? '''
Quantity: ${item.quantity}
${item.priceAsEuro}
${item.sweetnessAsString}
${item.milkAsString}
${item.comments}'''
                        .trim()
                    : 'Quantity: ${item.quantity}\n${item.priceAsEuro}\n${item.comments}'
                        .trim(), // trimming in case comments is empty string
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editItem(item);
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      _removeItem(item);
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _showFAB
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    NewOrderPage.customRoute(widget.order),
                  );
                },
                label: const Text('Add items'),
                icon: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
