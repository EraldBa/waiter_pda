import 'package:flutter/material.dart';
import 'package:waiter_pda/services/hive_helper.dart';

class RemoveMenuItemScreen extends StatefulWidget {
  const RemoveMenuItemScreen({super.key});

  @override
  State<RemoveMenuItemScreen> createState() => _RemoveMenuItemScreenState();
}

class _RemoveMenuItemScreenState extends State<RemoveMenuItemScreen> {
  @override
  Widget build(BuildContext context) {
    final menuItems = HiveHelper.menuItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove menu item'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = menuItems[index];

          return Card(
            key: Key(menuItem.name),
            child: ListTile(
              title: Text(menuItem.name),
              subtitle: Text(
                '${menuItem.priceAsEuro}${menuItem.ingredients}',
              ),
              isThreeLine: menuItem.ingredients.isNotEmpty,
              leading: Icon(menuItem.itemType.icon),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    menuItem.delete();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
