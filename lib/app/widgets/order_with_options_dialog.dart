import 'package:flutter/material.dart';
import 'package:waiter_pda/app/widgets/quantity_adjustment_box.dart';
import 'package:waiter_pda/models/order_item.dart';

class OrderOptionsDialog extends StatefulWidget {
  final OrderItem orderItem;

  const OrderOptionsDialog(this.orderItem, {super.key});

  @override
  State<OrderOptionsDialog> createState() => _OrderOptionsDialogState();
}

class _OrderOptionsDialogState extends State<OrderOptionsDialog> {
  static const double _height = 20.0;

  late final OrderItem _orderItem;

  @override
  void initState() {
    super.initState();
    _orderItem = OrderItem(menuItem: widget.orderItem.menuItem)
      ..setValuesFrom(widget.orderItem);
  }

  Iterable<Widget> get _coffeeOptions {
    if (!_orderItem.isCoffee) {
      return const Iterable.empty();
    }

    return [
      Container(
        alignment: Alignment.centerLeft,
        child: const Text('Select sweetness'),
      ),
      ...Sweetness.values.map(
        (value) {
          return RadioMenuButton(
            value: value,
            groupValue: _orderItem.sweetness,
            onChanged: (value) {
              setState(() {
                _orderItem.sweetness = value;
              });
            },
            child: Text(value.name),
          );
        },
      ),
      const SizedBox(height: _height),
      Container(
        alignment: Alignment.centerLeft,
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          itemBuilder: (context) {
            return Milk.values.map((value) {
              return CheckedPopupMenuItem(
                value: value,
                checked: _orderItem.milk == value,
                child: Text(value.name),
              );
            }).toList();
          },
          onSelected: (value) {
            setState(() {
              _orderItem.milk = value;
            });
          },
          child: Text(
            _orderItem.milkAsString,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ),
    ];
  }

  void _done() {
    widget.orderItem.setValuesFrom(_orderItem);

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Options Menu',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(_height),
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.orderItem.comments,
                decoration: const InputDecoration(
                  label: Text('Comments'),
                ),
                onChanged: (value) => _orderItem.comments = value,
              ),
              const SizedBox(height: _height),
              QuantityAdjustmentBox(orderItem: _orderItem),
              const SizedBox(height: _height),
              ..._coffeeOptions,
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _done,
          child: const Text('Done'),
        )
      ],
    );
  }
}
