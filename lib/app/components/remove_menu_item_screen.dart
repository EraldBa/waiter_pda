import 'package:flutter/material.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;

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
                  show
                      .alertDialog(context,
                          title: 'Conmfirmation needed',
                          message:
                              'Are you sure you want to delete item "${menuItem.name}" from the database?')
                      .then((confirmed) {
                    if (confirmed) {
                      setState(() {
                        menuItem.delete();
                      });
                    }
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
