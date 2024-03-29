// ignore_for_file: unnecessary_this

import 'package:hive/hive.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/menu_mixin.dart';

part 'order_item.g.dart';

@HiveType(typeId: 2)
class OrderItem extends HiveObject with MenuMixin {
  @HiveField(0)
  final MenuItem menuItem;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  Milk? milk;

  @HiveField(3)
  Sweetness? sweetness;

  @HiveField(4)
  String comments;

  OrderItem({
    required this.menuItem,
    this.quantity = 1,
    this.milk,
    this.sweetness,
    this.comments = '',
  });

  double get price => menuItem.price * quantity;

  String get priceAsEuro => 'Price: ${toStringEuro(price)}';

  String get milkAsString => 'Add milk: ${milk?.name ?? '-'}';

  String get sweetnessAsString => 'Sweetness: ${sweetness?.name ?? '-'}';

  bool get isCoffee => sweetness != null || milk != null;

  set values(OrderItem other) {
    this.quantity = other.quantity;
    this.comments = other.comments;
    this.milk = other.milk;
    this.sweetness = other.sweetness;
  }

  bool equals(OrderItem other) {
    return this.menuItem.equals(other.menuItem) &&
        this.comments == other.comments &&
        this.milk == other.milk &&
        this.sweetness == other.sweetness;
  }
}

@HiveType(typeId: 4)
enum Sweetness {
  @HiveField(0)
  sweet('Sweet'),

  @HiveField(1)
  medium('Medium'),

  @HiveField(2)
  slight('Slight'),

  @HiveField(3)
  none('None');

  final String name;

  const Sweetness(this.name);
}

@HiveType(typeId: 5)
enum Milk {
  @HiveField(0)
  fresh('Fresh'),

  @HiveField(1)
  canned('Canned'),

  @HiveField(2)
  almond('Almond');

  final String name;

  const Milk(this.name);
}
