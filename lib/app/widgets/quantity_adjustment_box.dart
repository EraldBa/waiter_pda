import 'package:flutter/material.dart';
import 'package:waiter_pda/models/order_item.dart';

class QuantityAdjustmentBox extends StatefulWidget {
  final OrderItem orderItem;

  const QuantityAdjustmentBox({super.key, required this.orderItem});

  @override
  State<QuantityAdjustmentBox> createState() => _QuantityAdjustmentBoxState();
}

class _QuantityAdjustmentBoxState extends State<QuantityAdjustmentBox> {
  void _incrementQuantity() {
    setState(() {
      ++widget.orderItem.quantity;
    });
  }

  void _decrementQuantity() {
    if (widget.orderItem.quantity > 1) {
      setState(() {
        --widget.orderItem.quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _decrementQuantity,
            icon: const Icon(Icons.remove),
          ),
          Text(
            widget.orderItem.quantity.toString(),
            style: const TextStyle(color: Colors.lightBlue),
          ),
          IconButton(
            onPressed: _incrementQuantity,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
