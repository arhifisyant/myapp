import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Inventory {
  String id = "";
  String name = "";
  String category = "";
  int stock = 0;
  String image = "";
  //late List subIngredients;
  List subIngredients = [];
  Timestamp createdAt = Timestamp(0,0);
  Timestamp updatedAt = Timestamp(0,0);

  Inventory();

  Inventory.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    stock = data['stock'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'stock' : stock,
      'image': image,
      'subIngredients': subIngredients,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  //Food({required this.id,required this.name,required this.category, required this.image, required this.subIngredients, required this.createdAt});
  }

}