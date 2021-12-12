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

    print("building Feed");
    return Scaffold(
      appBar: AppBar(
        title: Text(
         authNotifier.user!.displayName.toString(),
        ),
        centerTitle: true,
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () async {
             await signout(authNotifier);
             //await Navigator.pop(context);
             //await Navigator.push(context,
              // MaterialPageRoute(builder: (context) => Login()),
             //);
            },
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                inventoryNotifier.inventoryList[index].image, errorBuilder:
                  (BuildContext context, Object exception, StackTrace? stackTrace) {
                return  Image.network('https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',width: 120,
                    fit: BoxFit.fitWidth);},
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(inventoryNotifier.inventoryList[index].name),
              subtitle: Text(inventoryNotifier.inventoryList[index].category),
              onTap: () {
                inventoryNotifier.currentInventory = inventoryNotifier.inventoryList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return InventoryDetail();
                }));
              },
            );
          },
          itemCount: inventoryNotifier.inventoryList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
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


    );

  }
}