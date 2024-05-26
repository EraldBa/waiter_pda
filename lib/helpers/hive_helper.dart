import 'package:hive_flutter/hive_flutter.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

final class HiveHelper {
  static late final Box<MenuItem> menuItemBox;
  static late final Box<Order> orderBox;

  static bool _initComplete = false;

  HiveHelper._internal();

  // throws an exception if the method has already been called
  static Future<void> initHive() async {
    if (_initComplete) {
      throw Exception('Init has already been called');
    }

    await Hive.initFlutter();

    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());
    Hive.registerAdapter(MenuItemAdapter());
    Hive.registerAdapter(MilkAdapter());
    Hive.registerAdapter(SweetnessAdapter());
    Hive.registerAdapter(ItemTypesAdapter());

    orderBox = await Hive.openBox('orders');
    menuItemBox = await Hive.openBox('menuItems');

    _initComplete = true;
  }

  static List<MenuItem> get menuItems {
    return menuItemBox.values.cast<MenuItem>().toList();
  }

  static List<Order> get orders {
    return orderBox.values.cast<Order>().toList();
  }

  static Future<void> addMenuItem(MenuItem item) async {
    await menuItemBox.add(item);
  }

  static Future<void> addOrder(Order order) async {
    order.mergeItems();

    await orderBox.add(order);
  }

  static bool tableExistsInPending(String table) {
    return orderBox.values
        .cast<Order>()
        .any((order) => order.notCompleted && order.tableName == table);
  }
}
