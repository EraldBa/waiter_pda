import 'package:hive_flutter/hive_flutter.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/models/order_item.dart';

final class HiveHelper {
  static late final Box<MenuItem> _menuItemBox;
  static late final Box<Order> _orderBox;

  static bool _initComplete = false;

  HiveHelper._();

  static List<MenuItem> get menuItems {
    return _menuItemBox.values.cast<MenuItem>().toList();
  }

  static List<Order> get orders {
    return _orderBox.values.cast<Order>().toList();
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

    _orderBox = await Hive.openBox('orders');
    _menuItemBox = await Hive.openBox('menuItems');

    _initComplete = true;
  }

  static Future<void> addMenuItem(MenuItem item) async {
    await _menuItemBox.add(item);
  }

  static Future<void> addOrder(Order order) async {
    order.mergeItems();

    await _orderBox.add(order);
  }

  static void clearPendingOrders() {
    for (final order in _orderBox.values) {
      if (order.completed) {
        order.delete();
      }
    }
  }

  static bool menuItemExists(MenuItem item) {
    return _menuItemBox.values.any((menuItem) => menuItem.equals(item));
  }

  static bool tableExistsInPending(String tableName) {
    return _orderBox.values.any((order) {
      return order.notCompleted && order.tableName == tableName;
    });
  }
}
