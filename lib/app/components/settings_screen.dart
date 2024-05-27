import 'package:flutter/material.dart';
import 'package:waiter_pda/app/components/add_menu_item_dialog.dart';
import 'package:waiter_pda/app/components/remove_menu_item_screen.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Clear all completed orders'),
              onTap: () {
                show
                    .alertDialog(
                  context,
                  title: 'Do you wish to continue?',
                  message:
                      'This action will permanently delete all completed orders.',
                )
                    .then((confirmed) {
                  if (confirmed) {
                    HiveHelper.clearPendingOrders();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completed orders cleared'),
                      ),
                    );
                  }
                });
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new item to menu'),
              onTap: () {
                showDialog<bool>(
                  useSafeArea: true,
                  context: context,
                  builder: (context) => const AddMenuItemDialog(),
                ).then((itemWasAdded) {
                  if (itemWasAdded == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menu item was successfully added!'),
                      ),
                    );
                  }
                });
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.remove),
              title: const Text('Remove menu item'),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  useSafeArea: true,
                  builder: (context) => const RemoveMenuItemScreen(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
