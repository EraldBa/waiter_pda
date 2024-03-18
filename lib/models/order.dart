import 'package:hive/hive.dart';
import 'package:waiter_pda/models/menu_mixin.dart';
import 'package:waiter_pda/models/order_item.dart';

part 'order.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject with MenuMixin {
  @HiveField(0)
  final List<OrderItem> items;

  @HiveField(1)
  String tableName;

  @HiveField(2)
  bool completed;

  Order({
    required this.items,
    this.tableName = '',
    this.completed = false,
  });

  double get total {
    double sum = 0;

    for (final item in items) {
      sum += item.price;
    }

    return sum;
  }

  bool get notCompleted => !completed;

  String get totalAsEuro => toStringEuro(total);

  void mergeItems() {
    for (int i = 0; i < items.length; ++i) {
      final item = items[i];

      for (int j = i + 1; j < items.length; ++j) {
        final otherItem = items[j];

        if (item.equals(otherItem)) {
          item.quantity += otherItem.quantity;
          items.removeAt(j);
        }
      }
    }
  }

  @override
  Future<void> save() async {
    mergeItems();
    super.save();
  }
}
