import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'item_types.g.dart';

@HiveType(typeId: 6)
enum ItemTypes {
  @HiveField(0)
  all('All', Icons.circle),

  @HiveField(1)
  coffee('Coffee', Icons.coffee),

  @HiveField(2)
  drink('Drink', Icons.local_drink),

  @HiveField(3)
  food('Food', Icons.restaurant_menu_rounded);

  final String name;
  final IconData icon;

  const ItemTypes(this.name, this.icon);
}
