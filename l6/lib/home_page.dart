import 'package:flutter/material.dart';
import 'package:l6/cloud/cloud_database.dart';
import 'package:l6/cloud/cloud_path.dart';
import 'package:l6/item_form.dart';
import 'package:l6/item_provider.dart';
import 'package:l6/root.dart';
import 'package:provider/provider.dart';

import 'cloud/cloud_authentication.dart';

class HomePage extends StatefulWidget {
  final CloudAuthentication auth;
  final VoidCallback logoutCallBack;
  const HomePage({super.key, required this.auth, required this.logoutCallBack});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CloudDatabase _cloudDatabase = CloudDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Project'),
        actions: [
          IconButton(
            onPressed: () {
              widget.auth.signOut();
              widget.logoutCallBack();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RootPage(auth: widget.auth),
                ),
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: _displayItems(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ItemProvider itemProvider =
              Provider.of<ItemProvider>(context, listen: false);

          showDialog(
            context: context,
            builder: (context) => const Dialog(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ItemForm(),
              ),
            ),
          ).then((value) {
            if (null != value) {
              itemProvider.addItem(value);
            }
          });
        },
        label: const Text('ADD ITEM'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _displayItems() {
    return Consumer<ItemProvider>(
      builder: (BuildContext context, ItemProvider value, Widget? child) {
        if (null == value.itemList) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: value.itemList!.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(
                      value.itemList![index].data[CloudPath.dbKeyItemName]),
                  subtitle: Text(value
                      .itemList![index].data[CloudPath.dbKeyItemCost]
                      .toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            _editDocument(value.itemList![index]);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                      const SizedBox(
                        width: 8.0,
                      ),
                      IconButton(
                          onPressed: () {
                            _deleteDocument(value.itemList![index]);
                          },
                          icon: const Icon(
                            Icons.remove_shopping_cart,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _deleteDocument(Document document) {
    ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);
    itemProvider.deleteItem(document);
  }

  void _editDocument(Document document) {
    ItemProvider itemProvider =
        Provider.of<ItemProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ItemForm(
            item: document,
          ),
        ),
      ),
    ).then((value) {
      if (null != value) {
        itemProvider.updateItem(value);
      }
    });
  }
}
