import 'package:flutter/material.dart';
import 'package:waiter_pda/app/components/menu_item_dialog.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;

class EditMenuItemsScreen extends StatefulWidget {
  const EditMenuItemsScreen({super.key});

  @override
  State<EditMenuItemsScreen> createState() => _EditMenuItemsScreenState();
}

class _EditMenuItemsScreenState extends State<EditMenuItemsScreen> {
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
                '${menuItem.priceFmt}${menuItem.ingredientsFmt}',
              ),
              isThreeLine: menuItem.ingredients != null,
              leading: Icon(menuItem.itemType.icon),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        builder: (_) => MenuItemDialog(menuItem: menuItem),
                      ).then((itemEdited) {
                        if (itemEdited) {
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Menu item "${menuItem.name}" was edited successfully!',
                              ),
                            ),
                          );
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      show
                          .alertDialog(
                        context,
                        title: 'Confirmation needed',
                        message:
                            'Are you sure you want to delete item "${menuItem.name}" from the database?',
                      )
                          .then((confirmed) {
                        if (confirmed) {
                          setState(() {
                            menuItem.delete();
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Item "${menuItem.name}" deleted successfully!',
                              ),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
