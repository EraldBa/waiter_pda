import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waiter_pda/app/pages/home_page.dart';
import 'package:waiter_pda/app/pages/order_details_page.dart';
import 'package:waiter_pda/app/widgets/order_add_tile.dart';
import 'package:waiter_pda/extensions/string_extension.dart';
import 'package:waiter_pda/models/item_types.dart';
import 'package:waiter_pda/models/menu_item.dart';
import 'package:waiter_pda/models/order.dart';
import 'package:waiter_pda/helpers/hive_helper.dart';
import 'package:waiter_pda/helpers/show.dart' as show;

class NewOrderPage extends StatefulWidget {
  static const route = '/user-page';

  final Order order;

  const NewOrderPage({
    super.key,
    required this.order,
  });

  static MaterialPageRoute customRoute(Order order) {
    return MaterialPageRoute(
      builder: (context) {
        return NewOrderPage(order: order);
      },
    );
  }

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final _searchController = TextEditingController();

  final _scrollController = ScrollController();

  final List<MenuItem> _allMenuItems = HiveHelper.menuItems;

  final Map<ItemTypes, List<MenuItem>> _itemTypeLists = {};

  late List<MenuItem> _filteredMenuItems;

  ItemTypes _selectedItemType = ItemTypes.all;

  bool _isVisible = true;

  void _search(String text) {
    setState(() {
      if (text.isEmpty) {
        _filterItemsOnSelectedItem();
      } else {
        _filterItems(_itemTypeLists[_selectedItemType]!, text);
      }
    });
  }

  void _filterItems(List<MenuItem> items, String query) {
    _filteredMenuItems = items.where((menuItem) {
      return menuItem.name.toLowerCase().containsAll(query.toLowerCase());
    }).toList();
  }

  void _filterItemsOnSelectedItem() {
    _itemTypeLists[_selectedItemType] ??= _allMenuItems
        .where((item) => item.itemType == _selectedItemType)
        .toList();

    _filteredMenuItems = _itemTypeLists[_selectedItemType]!;
  }

  void _done() {
    if (widget.order.isInBox) {
      widget.order.save();
    } else {
      widget.order.mergeItems();

      HiveHelper.addOrder(widget.order);
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      HomePage.route,
      (route) => false,
    );
  }

  void _submitTable(String value) {
    if (HiveHelper.tableExistsInPending(value)) {
      show.warningDialog(context, 'Table already exists in Pending!');
      return;
    }

    widget.order.tableName = value;
  }

  set _setIsVisible(bool value) {
    setState(() {
      _isVisible = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _itemTypeLists[ItemTypes.all] = _filteredMenuItems = _allMenuItems;

    _searchController.addListener(() {
      _search(_searchController.text);
    });

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse) {
        _setIsVisible = false;
      } else if (direction == ScrollDirection.forward) {
        _setIsVisible = true;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _setIsVisible = true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Order'),
          leadingWidth: 70.0,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          actions: [
            TextButton(
              onPressed: _done,
              child: const Text('Done'),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: TextFormField(
                initialValue: widget.order.tableName,
                onFieldSubmitted: _submitTable,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Table',
                  constraints: BoxConstraints.expand(width: 60.0, height: 45.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
              child: SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search),
                hintText: 'Search for menu item',
                trailing: [
                  IconButton(
                    onPressed: _searchController.clear,
                    icon: const Icon(Icons.clear),
                  )
                ],
                onTap: () => _setIsVisible = false,
              ),
            ),
            SegmentedButton(
              segments: ItemTypes.values.map((value) {
                return ButtonSegment(
                  value: value,
                  label: Text(value.name),
                  icon: Icon(value.icon),
                );
              }).toList(),
              selected: <ItemTypes>{_selectedItemType},
              onSelectionChanged: (p0) {
                setState(() {
                  _selectedItemType = p0.first;
                  _filterItemsOnSelectedItem();
                });
              },
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredMenuItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredMenuItems[index];

                  return OrderAddTile(
                    key: ValueKey(item),
                    menuItem: item,
                    order: widget.order,
                  );
                },
              ),
            )
          ],
        ),
        floatingActionButton: _isVisible
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return OrderDetailsPage(
                          order: widget.order,
                          ordersAreSaved: false,
                        );
                      },
                    );
                  },
                  label: const Text('View order'),
                  icon: const Icon(Icons.remove_red_eye_outlined),
                ),
              )
            : null,
      ),
    );
  }
}
