// ignore_for_file: prefer_const_constructors
import 'package:myapp/services/database.dart';
import 'package:myapp/model/inventory.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inventory_form.dart';

class InventoryDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    InventoryNotifier inventoryNotifier = Provider.of<InventoryNotifier>(context);

    _onInventoryDeleted(Inventory inventory) {
      Navigator.pop(context);
      inventoryNotifier.deleteInventory(inventory);
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(inventoryNotifier.currentInventory!.name),
      ),
      body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(inventoryNotifier.currentInventory!.image, errorBuilder:
                    (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.network(
                      'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg');
                }),
                SizedBox(height: 24),
                Center(
                  child: Text(
                    inventoryNotifier.currentInventory!.name,
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,20.0,0.0,0.0),
                  child: Text(
                    'Kategori: ${inventoryNotifier.currentInventory!.category}'
                    '\n' 'Stok: ${inventoryNotifier.currentInventory!.stock}',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,20.0,0.0,0.0),
                  child: Text(
                    "Komposisi",
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: inventoryNotifier.currentInventory!.subIngredients
                      .map(
                        (ingredient) =>
                        Card(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              ingredient,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                  )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return UksInventory(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () =>
            deleteInventory(inventoryNotifier.currentInventory!, _onInventoryDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),

    );
  }
}
