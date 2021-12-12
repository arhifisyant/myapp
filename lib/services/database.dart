import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/model/inventory.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

login(MyUser? user, AuthNotifier? authNotifier) async {

  UserCredential? authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user!.email.toString(), password: user.password.toString())
      .catchError((error) => print(error.code));

  if (authResult != null) {
    User? firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier!.setUser(firebaseUser);
    }
  }
}

signup(MyUser? user, AuthNotifier? authNotifier) async {
  UserCredential?  authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user!.email.toString(), password: user.password.toString())
      .catchError((error) => print(error.code));

  if (authResult != null) {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(user.displayName);
    //UserUpdateInfo updateInfo = UserUpdateInfo();
    //updateInfo.displayName = user.displayName;
    User? firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateDisplayName(user.displayName);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      User? currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier!.setUser(currentUser!);
    }
  }
}

signout(AuthNotifier? authNotifier) async {

  try{
    await FirebaseAuth.instance.signOut();
    print(FirebaseAuth.instance.currentUser);
    authNotifier!.setUser(null);
    return FirebaseAuth.instance.currentUser;
  } catch(e){
    print(e.toString());
    return null;
 }
//
//
 // await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));
 // User? firebaseUser = FirebaseAuth.instance.currentUser;
 // //dynamic singOutUser;
  //User? firebaseUser = singOutUser as User?;
  //authNotifier.setUser(firebaseUser!);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User? firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getInventory(InventoryNotifier inventoryNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Inventory')
      .orderBy("createdAt",descending: false)
      .get();

  List<Inventory> _inventoryList = [];

  snapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
    Inventory inventory = Inventory.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    _inventoryList.add(inventory);
    print(inventory);
  });

  inventoryNotifier.inventoryList = _inventoryList;
}

uploadInventoryAndImage(Inventory inventory, bool isUpdating, File? localFile, Function inventoryUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();


    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('inventory/images/$uuid$fileExtension');

    //final StorageReference firebaseStorageRef =
    //FirebaseStorage.instance.ref().child('inventory/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).whenComplete((){
      return false;


    });



    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");

    _uploadInventory(inventory, isUpdating, inventoryUploaded, imageUrl: url);


  } else {
    print('...skipping image upload');
    _uploadInventory(inventory, isUpdating, inventoryUploaded);

  }
}

_uploadInventory(Inventory inventory, bool isUpdating, Function inventoryUploaded, {String? imageUrl}) async {
  CollectionReference invRef = FirebaseFirestore.instance.collection('Inventory');

  if (imageUrl != null) {
    inventory.image = imageUrl.toString();
    print(imageUrl);
  }

  if (isUpdating) {
    inventory.updatedAt = Timestamp.now();

    await invRef.doc(inventory.id).update(inventory.toMap());

    inventoryUploaded(inventory);
    print('updated inventory with id: ${inventory.id}');

  }else{

    inventory.createdAt = Timestamp.now();

    DocumentReference documentRef = await invRef.add(inventory.toMap());

    inventory.id = documentRef.id;

   // DocumentReference documentRef = await invRef.add(inventory.toMap());

   // DocumentSnapshot docSnap = await documentRef.get();

   // inventory.id = docSnap.reference.id.toString();

    print('uploaded inventory successfully: ${inventory.toString()}');

    print(inventory.id);

   // await documentRef.setData(inventory.toMap(), merge: true);

    await invRef.doc(inventory.id).set(inventory.toMap(),SetOptions(merge: true));
    inventoryUploaded(inventory);
  }
}


deleteInventory(Inventory inventory, Function inventoryDeleted) async {
  if (inventory.image != "") {
    Reference storageReference =
    await FirebaseStorage.instance.refFromURL(inventory.image);

    print(storageReference.toString());

    await storageReference.delete();

    print('image deleted');
  }

  await FirebaseFirestore.instance.collection('Inventory').doc(inventory.id).delete();
  inventoryDeleted(inventory);
}