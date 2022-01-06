import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:myapp/screens/login.dart';
import 'package:provider/provider.dart';

import 'details.dart';
import 'inventory_form.dart';

class Feed extends StatefulWidget {
 // const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}



class _FeedState extends State<Feed>{
 // const Feed({required Key key}) : super(key: key);

  @override
  void initState() {
     InventoryNotifier inventoryNotifier = Provider.of<InventoryNotifier>(context,listen: false);
    getInventory(inventoryNotifier);
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier? authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    InventoryNotifier inventoryNotifier = Provider.of<InventoryNotifier>(context);
    final Size size = MediaQuery.of(context).size;

    print("building Feed");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0.0,
          actions: <Widget>[
            // action button
            IconButton(
             // label: Text("keluar", style: TextStyle(color: Colors.white),),
              icon : Icon (Icons.logout, color: Colors.white,),
              onPressed: () async {
               await signout(authNotifier);
               //await Navigator.pop(context);
               //await Navigator.push(context,
                // MaterialPageRoute(builder: (context) => Login()),
               //);
              },
            ),
          ],
        ),
        body : Container(
          color: Colors.blue,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column (
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0,0.0, 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.blue,
                        child: Text("Selamat datang,",style: GoogleFonts.openSans(color:Colors.white,fontSize:14),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0,0.0, 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text( authNotifier.user!.displayName.toString(),
                          style: GoogleFonts.openSans(
                            color:Colors.white,
                            fontSize:25,
                          fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ),
                  Container(
                      child: Text("Inventaris UKS",
                        style: GoogleFonts.openSans(
                            color:Colors.white,
                            fontSize:25,
                            fontWeight: FontWeight.w800),),
                    ),
                  SizedBox(height: 20.0,),

                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                        child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                    inventoryNotifier.inventoryList[index].image,
                                  ),
                                ),
                                title: Text(inventoryNotifier.inventoryList[index].name,
                                  style: GoogleFonts.openSans(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600

                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(inventoryNotifier.inventoryList[index].category,
                                        style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    Text("Stok : ${inventoryNotifier.inventoryList[index].stock.toString()}",
                                      style: GoogleFonts.openSans(
                                          fontSize: 18,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                onTap: () {
                                  inventoryNotifier.currentInventory = inventoryNotifier.inventoryList[index];
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return InventoryDetail();
                                  }));
                                },
                              ),
                            ),
                          ),
                        );
                  },
                        itemCount: inventoryNotifier.inventoryList.length,
                  ),
                      ),
                    ),

                  )
                ]

                  ),
          ),

        ),
        floatingActionButton: FloatingActionButton(
          //onPressed: () => {},
          onPressed: () {
            inventoryNotifier.currentInventory = null;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return UksInventory(
                  isUpdating: false,
                );
              }),
            );
          },
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
        ),


      ),
    );

  }
}