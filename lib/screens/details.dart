// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:myapp/screens/feed.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/model/inventory.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'inventory_form.dart';

class InventoryDetail extends StatelessWidget {
  const InventoryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryNotifier inventoryNotifier = Provider.of<InventoryNotifier>(context);

    _onInventoryDeleted(Inventory inventory) {
      Navigator.pop(context);
      inventoryNotifier.deleteInventory(inventory);
    }



    return
      Scaffold(
        body: SafeArea(
          child: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.blue[20],
                  expandedHeight: MediaQuery.of(context).size.height*0.4,
                  flexibleSpace: Container(
                    height: MediaQuery.of(context).size.height*0.5,
                    color: Colors.blue[10],
                    child: Stack(
                      children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton(
                              icon: Icon(Icons.more_vert,
                                color: Colors.white),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child:  Row(
                                    children: const <Widget>[
                                      Icon(Icons.edit, color: Colors.blue),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('Ubah'),
                                      ),
                                    ],
                                  ),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child:  Row(
                                    children: const <Widget>[
                                      Icon(Icons.delete, color: Colors.red),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('Hapus',),
                                      ),
                                    ],
                                  ),
                                  value: 1,
                                ),
                              ],
                              onSelected: (result) {
                                if (result == 0) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return UksInventory(
                                        isUpdating: true,
                                      );
                                    }),
                                  );
                                }
                                if (result == 1) {
                                  deleteInventory(inventoryNotifier.currentInventory!, _onInventoryDeleted);
                                }
                              },

                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom:50),
                            width: 225,
                            height: 172,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  inventoryNotifier.currentInventory!.image,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          Padding(
                              padding: EdgeInsets.only(top:20, left: 25),
                              child: Text("Nama Barang",
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold
                              ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:7, left: 25),
                              child: Text(inventoryNotifier.currentInventory!.name,
                                style: GoogleFonts.openSans(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600

                                ),
                              )
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(top:20, left: 25),
                                        child: Text("Kategori",
                                          style: GoogleFonts.openSans(
                                              fontSize: 12,
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top:7, left: 25),
                                        child: Text(inventoryNotifier.currentInventory!.category,
                                          style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400

                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(top:20, left: 25),
                                        child: Text("Stok",
                                          style: GoogleFonts.openSans(
                                              fontSize: 12,
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top:7, left: 25),
                                        child: Text(inventoryNotifier.currentInventory!.stock.toString(),
                                          style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400

                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:20, left: 25),
                              child: Text("Tanggal Kadarluasa",
                                style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:7, left: 25),
                              child: Text(inventoryNotifier.currentInventory!.expirationDate,
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400

                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:24, left: 25),
                              child: Text("Komposisi",
                                style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold

                                ),
                              )
                          ),

                          GridView.count(
                            childAspectRatio: MediaQuery.of(context).size.height / 600,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(20),
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 3,
                            children: inventoryNotifier.currentInventory!.subIngredients
                                .map(
                                  (ingredient) =>
                                  Card(
                                    color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          ingredient,
                                          style: GoogleFonts.openSans(
                                              color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                            )
                                .toList(),
                          )
                        ]
                    )

                )
              ],
            ),


          )
        ),
   /*     floatingActionButton: Column(
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
*/
      );
  }
}
