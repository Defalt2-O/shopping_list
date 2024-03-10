import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({
    super.key,
  });

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    final itemIndex = _groceryItems.indexOf(item);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item has been removed...'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _groceryItems.insert(itemIndex, item);
            });
          },
        ),
      ),
    );
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGroceryListEmpty = _groceryItems.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isGroceryListEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Uh Oh! No items in your bag!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white54, fontSize: 27),
                  ),
                  Text(
                    'You wanna add some...maybe?',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white54, fontSize: 20),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: ValueKey(
                    _groceryItems[index],
                  ),
                  onDismissed: (direction) {
                    _removeItem(
                      _groceryItems[index],
                    );
                  },
                  child: ListTile(
                    title: Text(_groceryItems[index].name),
                    leading: Icon(
                      Icons.square,
                      color: _groceryItems[index].category.color,
                    ),
                    trailing: Text(
                      _groceryItems[index].quantity.toString(),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
