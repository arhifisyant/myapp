import 'dart:collection';

import 'package:myapp/model/inventory.dart';
import 'package:flutter/cupertino.dart';

class InventoryNotifier with ChangeNotifier {
  List<Inventory> _inventoryList = [];
  Inventory? _currentInventory;

  UnmodifiableListView<Inventory> get inventoryList => UnmodifiableListView(_inventoryList);

  Inventory? get currentInventory => _currentInventory;

  set inventoryList(List<Inventory> inventoryList) {
    _inventoryList = inventoryList;
    notifyListeners();
  }

  set currentInventory(Inventory? inventory) {
    _currentInventory = inventory;
    notifyListeners();
  }

  addInventory(Inventory inventory) {
    _inventoryList.insert(0, inventory);
    notifyListeners();
  }

  deleteInventory(Inventory inventory) {
    _inventoryList.removeWhere((_inventory) => _inventory.id == inventory.id);
    notifyListeners();
  }


}