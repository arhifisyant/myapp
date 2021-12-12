// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/model/inventory.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


class UksInventory extends StatefulWidget {
  //const FoodForm({Key? key}) : super(key: key);

  final bool isUpdating;

  const UksInventory({Key? key, required this.isUpdating}) : super(key: key);


  @override
  _UksInventoryState createState() => _UksInventoryState();
}

class _UksInventoryState extends State<UksInventory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _subingredients = [];
  Inventory _currentInventory = Inventory();
  String _imageUrl = "";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController subingredientController = new TextEditingController();
  String? currentInventory;
  final List<String> mycategory = ['','Obat Cair','Tablet','Kapsul','Obat oles','Obat Tetes','Inhaler'];


  @override
  void initState() {
    super.initState();
    InventoryNotifier inventoryNotifier = Provider.of<InventoryNotifier>(context, listen: false);

    if (inventoryNotifier.currentInventory != null) {
      _currentInventory = inventoryNotifier.currentInventory!;
    } else {
      _currentInventory = Inventory();
    }

    _subingredients.addAll(_currentInventory.subIngredients);
    _imageUrl = _currentInventory.image;
  }


  _showImage(){

    if (_imageFile == null && _imageUrl == "") {
      return Text("");

    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(File( _imageFile!.path ),
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );

    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async{
    XFile? imageFile =
        await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 50,
            maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nama Obat'),
      initialValue: _currentInventory.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Nama Obat wajib diisi';
        }

        if (value.length < 3 || value.length > 50) {
          return 'Nama obat harus lebih dari tiga karakter';
        }

        return null;
      },
      onSaved: (String? value) {
        _currentInventory.name = value!;
      },
    );
  }


  Widget _buildCategoryField() {
    return  DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Kategori'),
      value: currentInventory ?? _currentInventory.category,
      onChanged: (String? value) {
        setState(() => currentInventory = value as String);
      },
      onSaved: (String? value) {
        _currentInventory.category = value!;
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Kategori wajib diisi';
        }

        return null;
      },
      items: mycategory.map((category) {
        return DropdownMenuItem(
          child: Text("$category"),
          value: category,
        );
      }).toList(),
    );
  }

  Widget _buildStockField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Stok'),
      initialValue: _currentInventory.stock.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      style: TextStyle(fontSize: 20),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Stok wajib diisi';
        }
        return null;
      },
      onSaved: (String? value) {
        _currentInventory.stock = int.parse(value!);
      },
    );
  }


  _buildSubingredientField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: subingredientController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Komposisi'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onInventoryUploaded(Inventory inventory) {
    InventoryNotifier inventoryNotifier = Provider.of<InventoryNotifier>(context, listen: false);
    inventoryNotifier.addInventory(inventory);
    Navigator.pop(context);
  }



  _addSubingredient(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subingredients.add(text);
      });
      subingredientController.clear();
    }
  }

  _saveInventory() {
    print('saveInventory Called');
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    print('form saved');

    _currentInventory.subIngredients = _subingredients;

    uploadInventoryAndImage(_currentInventory, widget.isUpdating, _imageFile, _onInventoryUploaded );

    print("name: ${_currentInventory.name}");
    print("category: ${_currentInventory.category}");
    print("subingredients: ${_currentInventory.subIngredients.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (title: Text('Form Inventaris')),
        body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
    child: Form(
    key: _formKey,
    autovalidate: true,
    child: Column(children: <Widget>[
    _showImage(),
      SizedBox(height: 16),
      Text(
        widget.isUpdating ? "Edit Inventaris" : "Buat Inventaris",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
      SizedBox(height: 16),
      _imageFile == null && _imageUrl == "" ?
      ButtonTheme(
        child: RaisedButton(
          onPressed: () => {
            _getLocalImage(),
          },
          child: Text(
            'Tambah Gambar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ) : SizedBox(height:0),
        _buildNameField(),
        _buildCategoryField(),
        _buildStockField(),
        SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildSubingredientField(),
          ButtonTheme(
            child: RaisedButton(
              child: Text('Tambah', style: TextStyle(color: Colors.white)),
             onPressed: () => _addSubingredient(subingredientController.text),
            ),
          )
        ],
      ),
      GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(8),
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: _subingredients
            .map(
              (ingredient) => Card(
            color: Colors.black54,
            child: Center(
              child: Text(
                ingredient,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ).toList(),
        ),
      ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // FocusScope.of(context).requestFocus(new FocusNode());
          _saveInventory();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
