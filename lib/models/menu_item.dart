// ignore_for_file: unnecessary_this

import 'package:hive/hive.dart';
import 'package:waiter_pda/helpers/price_helper.dart' as price_helper;
import 'package:waiter_pda/models/item_types.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 3)
final class MenuItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  ItemTypes itemType;

  @HiveField(3)
  String? ingredients;

  MenuItem({
    required this.name,
    required this.price,
    required this.itemType,
    this.ingredients,
  });

  MenuItem.empty()
      : name = '',
        price = 0.0,
        itemType = ItemTypes.all;

  String get ingredientsFmt =>
      ingredients == null ? '' : '\nIngredients: ${ingredients!}';

  String get priceFmt => 'Price: ${price_helper.toEuroFormat(price)}';

  bool equals(MenuItem other) {
    return this.name == other.name && this.price == other.price;
  }
}
