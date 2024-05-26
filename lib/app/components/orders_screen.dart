import 'package:flutter/material.dart';
import 'package:waiter_pda/app/pages/new_order_page.dart';
import 'package:waiter_pda/app/widgets/slidable_order.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/models/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    // sorting orders in ascending order
    final orders = HiveHelper.orders
      ..sort((a, b) {
        return a.tableName.compareTo(b.tableName);
      });

    final completedOrders = <Order>[];
    final pendingOrders = <Order>[];

    for (final order in orders) {
      if (order.completed) {
        completedOrders.add(order);
      } else {
        pendingOrders.add(order);
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Orders'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Pending',
                icon: Badge.count(
                  isLabelVisible: pendingOrders.isNotEmpty,
                  backgroundColor: Colors.blue,
                  count: pendingOrders.length,
                  child: const Icon(Icons.pending_actions),
                ),
                iconMargin: EdgeInsets.zero,
              ),
              const Tab(
                text: 'Completed',
                icon: Icon(Icons.done),
                iconMargin: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  OrderScreenBody(
                    orders: pendingOrders,
                    setParentState: setState,
                  ),
                  OrderScreenBody(
                    orders: completedOrders,
                    setParentState: setState,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('New order'),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(NewOrderPage.route);
          },
        ),
      ),
    );
  }
}

class OrderScreenBody extends StatelessWidget {
  final List<Order> orders;

  final void Function(VoidCallback) setParentState;

  const OrderScreenBody({
    super.key,
    required this.orders,
    required this.setParentState,
  });

  Widget _seperatorBuilder(BuildContext context, int index) {
    return Divider(
      color: Theme.of(context).colorScheme.inversePrimary,
      height: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setParentState(() {});
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: _seperatorBuilder,
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return SlidableOrder(
            key: UniqueKey(),
            order: orders[index],
            setParentState: setParentState,
          );
        },
      ),
    );
  }
}
