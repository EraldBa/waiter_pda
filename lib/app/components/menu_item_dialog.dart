import 'package:flutter/material.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';

class MenuItemDialog extends StatefulWidget {
  const MenuItemDialog({super.key, this.menuItem});

  final MenuItem? menuItem;

  @override
  State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();

  late final MenuItem menuItem;

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }

    menuItem.name = value;

    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price cannot be empty';
    }
    try {
      menuItem.price = double.parse(value);
    } catch (_) {
      return 'Price provided is not valid';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    menuItem = widget.menuItem ?? MenuItem.empty();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new menu item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: menuItem.name,
                validator: _nameValidator,
                decoration: const InputDecoration(
                  labelText: 'Name*',
                ),
              ),
              TextFormField(
                initialValue: menuItem.ingredients,
                decoration: const InputDecoration(labelText: 'Ingredients'),
                onChanged: (value) {
                  menuItem.ingredients = value;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: menuItem.price.toString(),
                      keyboardType: TextInputType.number,
                      validator: _priceValidator,
                      decoration: const InputDecoration(
                        labelText: 'Price*',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Item Type'),
                        PopupMenuButton(
                          position: PopupMenuPosition.under,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          itemBuilder: (context) {
                            return ItemTypes.values.map((value) {
                              return CheckedPopupMenuItem(
                                value: value,
                                checked: menuItem.itemType == value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(value.name),
                                    Icon(value.icon),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          onSelected: (value) {
                            setState(() {
                              menuItem.itemType = value;
                            });
                          },
                          child: Icon(menuItem.itemType.icon),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            if (widget.menuItem == null &&
                HiveHelper.menuItemExists(menuItem)) {
              show.warningDialog(
                context,
                'Menu item already exists in the database!',
              );
            } else {
              if (menuItem.isInBox) {
                menuItem.save();
              } else {
                HiveHelper.addMenuItem(menuItem);
              }

              Navigator.of(context).pop(true);
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
