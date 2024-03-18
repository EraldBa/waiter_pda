import 'package:flutter/material.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/services/hive_helper.dart';

class AddMenuItemDialog extends StatefulWidget {
  const AddMenuItemDialog({super.key});

  @override
  State<AddMenuItemDialog> createState() => _AddMenuItemDialogState();
}

class _AddMenuItemDialogState extends State<AddMenuItemDialog> {
  final _formKey = GlobalKey<FormState>();

  ItemTypes _itemType = ItemTypes.all;

  String _name = '';

  String? _ingredients;

  double _price = 0.0;

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }

    _name = value;

    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price cannot be empty';
    }
    try {
      _price = double.parse(value);
    } catch (_) {
      return 'Price provided not valid';
    }

    return null;
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
                validator: _nameValidator,
                decoration: const InputDecoration(
                  labelText: 'Name*',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ingredients'),
                onChanged: (value) {
                  _ingredients = value;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
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
                                checked: _itemType == value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(value.icon),
                                    Text(value.name),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          onSelected: (value) {
                            setState(() {
                              _itemType = value;
                            });
                          },
                          child: Icon(_itemType.icon),
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
            if (_formKey.currentState!.validate()) {
              final menuItem = MenuItem(
                name: _name.trim(),
                price: _price,
                itemType: _itemType,
                ingredients: _ingredients,
              );

              HiveHelper.addMenuItem(menuItem);

              Navigator.of(context).pop(true);
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
