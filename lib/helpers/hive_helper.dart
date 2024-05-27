import 'package:hive_flutter/hive_flutter.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

final class HiveHelper {
  static late final Box<MenuItem> menuItemBox;
  static late final Box<Order> orderBox;

  static bool _initComplete = false;

  HiveHelper._();

  static List<MenuItem> get menuItems {
    return menuItemBox.values.cast<MenuItem>().toList();
  }

  static List<Order> get orders {
    return orderBox.values.cast<Order>().toList();
  }

  /// throws [Exception] if the method has already been called
  static Future<void> initHive() async {
    if (_initComplete) {
      throw Exception('initHive cannot be called more than once');
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

  /// throws [Exception] if menu item provided already exists
  /// in the database
  static Future<void> addMenuItem(MenuItem item) async {
    if (menuItemExists(item)) {
      throw Exception('Menu item already exists!');
    }

    await menuItemBox.add(item);
  }

  /// throws [Exception] if tableName property already exists
  /// in some order inside of [orderBox]
  static Future<void> addOrder(Order order) async {
    if (tableExistsInPending(order.tableName)) {
      throw Exception('Table already exists in pending!');
    }

    order.mergeItems();

    await orderBox.add(order);
  }

  static bool menuItemExists(MenuItem item) {
    return menuItemBox.values
        .cast<MenuItem>()
        .any((menuItem) => menuItem.equals(item));
  }

  static bool tableExistsInPending(String tableName) {
    return orderBox.values
        .cast<Order>()
        .any((order) => order.notCompleted && order.tableName == tableName);
  }
}
