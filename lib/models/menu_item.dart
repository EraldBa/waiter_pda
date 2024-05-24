// ignore_for_file: unnecessary_this

import 'package:hive/hive.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/price_helper.dart' as price_helper;

part 'menu_item.g.dart';

@HiveType(typeId: 3)
final class MenuItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  @HiveField(2)
  final ItemTypes itemType;

  @HiveField(3)
  final String? _ingredients;

  MenuItem({
    required this.name,
    required this.price,
    required this.itemType,
    String? ingredients,
  }) : _ingredients = ingredients;

  String get ingredients {
    return _ingredients == null ? '' : '\nIngredients: ${_ingredients!}';
  }

  String get priceAsEuro => 'Price: ${price_helper.toEuroFormat(price)}';

  bool equals(MenuItem other) {
    return this.name == other.name && this.price == other.price;
  }
}
