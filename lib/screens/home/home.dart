import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';

class Home extends StatelessWidget {
//  const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          )
        ],
      )
    );
  }
}
