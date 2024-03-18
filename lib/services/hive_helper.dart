import 'package:hive_flutter/hive_flutter.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

final class HiveHelper {
  static Future<void> initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());
    Hive.registerAdapter(MenuItemAdapter());
    Hive.registerAdapter(MilkAdapter());
    Hive.registerAdapter(SweetnessAdapter());
    Hive.registerAdapter(ItemTypesAdapter());

    await Hive.openBox('orders');
    await Hive.openBox('menuItems');
  }

  static List<MenuItem> get menuItems {
    return Hive.box('menuItems').values.cast<MenuItem>().toList();
  }

  static List<Order> get orders {
    return Hive.box('orders').values.cast<Order>().toList();
  }

  static Future<void> addMenuItem(MenuItem item) async {
    await Hive.box('menuItems').add(item);
  }

  static Future<void> addOrder(Order order) async {
    await Hive.box('orders').add(order);
  }

  static bool tableExistsInPending(String table) {
    return Hive.box('orders')
        .values
        .cast<Order>()
        .any((order) => order.notCompleted && order.tableName == table);
  }
}
