import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/brew.dart';
import 'package:myapp/screens/home/brew_list.dart';
import 'package:myapp/screens/home/setings_form.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
//  const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 60.0),
          child: SettingsForm(),
        );

      });

    }



    return StreamProvider<List<Brew>>.value(
      initialData: [],
      value: DatabaseService(uid:'').brews,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text('My App'),
          backgroundColor: Colors.blue[500],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon : Icon (Icons.person),
              label : Text ('logout'),
              onPressed: () async {
                await _auth.signOut();

              },
            ),
            FlatButton.icon(
                icon: Icon(Icons.settings),
                label: Text('settings'),
                onPressed: () => _showSettingsPanel()
            ),
          ],
        ),
      body: Container(
          decoration: BoxDecoration(
            image : DecorationImage(
              image : AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover,
          ),
          ),
          child: BrewList()),
      ),
    );
  }
}
