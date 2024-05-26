import 'package:hive/hive.dart';
import 'package:waiter_pda/models/order_item.dart';
import 'package:waiter_pda/models/price_helper.dart' as price_helper;

part 'order.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject {
  @HiveField(0)
  final List<OrderItem> items;

  @HiveField(1)
  String tableName;

  @HiveField(2)
  bool completed;

  @HiveField(3)
  late final DateTime _createdAt;

  @HiveField(4)
  late DateTime _updatedAt;

  Order({
    required this.items,
    this.tableName = '',
    this.completed = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _createdAt = createdAt ?? DateTime.now(),
        _updatedAt = updatedAt ?? DateTime.now();

  double get total {
    double sum = 0;

    for (final item in items) {
      sum += item.price;
    }

    return sum;
  }

  int get itemCount {
    int count = 0;

    for (final item in items) {
      count += item.quantity;
    }

    return count;
  }

  bool get notCompleted => !completed;

  String get totalAsEuro => price_helper.toEuroFormat(total);

  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;

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

    _updatedAt = DateTime.now();

    super.save();
  }
}
