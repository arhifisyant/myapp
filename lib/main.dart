import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:myapp/screens/feed.dart';
import 'package:myapp/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifier/auth_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthNotifier(),
          ),
        ChangeNotifierProvider(
          create: (context) => InventoryNotifier(),
        )
        ],
        child: MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding with Curry',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.blue,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Feed() : Login();
        },
      ),
    );
  }
}