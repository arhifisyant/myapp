// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/model/inventory.dart';
import 'package:myapp/notifier/inventory_notifier.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


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
  TextEditingController dateinput = TextEditingController();
  String? currentInventory;

  final List<String> mycategory = ['','Obat Cair','Tablet','Kapsul','Obat Oles','Obat Tetes','Inhaler','Peralatan Kesehatan','Lain-lain'];


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
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.file(File( _imageFile!.path ),
            fit: BoxFit.fill,
            height: 200,
          ),
          TextButton(
            //padding: EdgeInsets.all(16),
              style: TextButton.styleFrom(
              backgroundColor: Colors.black26,
              elevation: 1.0,
            ),
            child: Text(
              'Ubah Gambar',
              style: GoogleFonts.openSans(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );

    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.fitWidth,
           // height: 250,
          ),
          TextButton(
            //padding: EdgeInsets.all(16),
              style: TextButton.styleFrom(
              backgroundColor: Colors.black26,
              elevation: 1.0,
            ),
            child: Text(
              'Ubah Gambar',
              style: GoogleFonts.openSans(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
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
            maxWidth: 500);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "Nama Barang",
            border: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.blueAccent, width: 2),
            ),
            // hintText: _currentInventory.expirationDate,
            floatingLabelBehavior: FloatingLabelBehavior.always),
        initialValue: _currentInventory.name,
        keyboardType: TextInputType.text,
        style: GoogleFonts.openSans(fontSize: 20),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Nama barang wajib diisi';
          }

          if (value.length < 3 || value.length > 50) {
            return 'Nama barang harus lebih dari tiga karakter';
          }

          return null;
        },
        onSaved: (String? value) {
          _currentInventory.name = value!;
        },
      ),
    );
  }


  Widget _buildCategoryField() {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: "Kategori",
            border: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.blueAccent, width: 2),
            ),
            // hintText: _currentInventory.expirationDate,
            floatingLabelBehavior: FloatingLabelBehavior.always),
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
      ),
    );
  }

  Widget _buildStockField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "Stok",
            border: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.blueAccent, width: 2),
            ),
           // hintText: _currentInventory.expirationDate,
            floatingLabelBehavior: FloatingLabelBehavior.always),
        initialValue: _currentInventory.stock.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        style: GoogleFonts.openSans(fontSize: 20),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Stok wajib diisi';
          }
          return null;
        },
        onSaved: (String? value) {
          _currentInventory.stock = int.parse(value!);
        },
      ),
    );
  }


  _buildSubingredientField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
      child: SizedBox(
        width: 200,
        child: TextField(
          controller: subingredientController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Komposisi",
              border: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.blueAccent, width: 2),
              ),
              // hintText: _currentInventory.expirationDate,
              floatingLabelBehavior: FloatingLabelBehavior.always),
          style: GoogleFonts.openSans(fontSize: 20),
        ),
      ),
    );
  }

  _buildExpirationDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 40.0, 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 200,
            child: TextFormField (
              controller: dateinput , //editing controller of this TextField
              decoration: InputDecoration(
                  labelText: "Kadaluarsa",
                  border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  hintText: _currentInventory.expirationDate,
                  hintStyle: GoogleFonts.openSans(color: Colors.black,),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
              //readOnly: true,  //set it true, so that user will not able to edit text
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                DateTime? pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101)
                );

                if(pickedDate != null ){
                  print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  print(formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement
                  setState(() {
                    dateinput.text = formattedDate; //set output date to TextField value.
                  });
                }else{
                  print("Tanggal belum dipilih");
                }
                print(dateinput.text);
                },

              onSaved: (String? value) {
                if (dateinput.text.isEmpty){
                  _currentInventory.expirationDate =  _currentInventory.expirationDate;
                }
                else
                _currentInventory.expirationDate = dateinput.text;
              },
            )
        ),
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
        //padding: EdgeInsets.all(10),
    child: Form(
    autovalidateMode: AutovalidateMode.always, key: _formKey,
    child: Column(children: <Widget>[
    _showImage(),
      SizedBox(height: 16),
      Text(
        widget.isUpdating ? "Ubah Detail Barang" : "Masukan Barang Baru",
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
            fontSize: 25,
            fontWeight: FontWeight.w600,),
      ),
      SizedBox(height: 16),
      _imageFile == null && _imageUrl == "" ?
      ButtonTheme(
        child: ElevatedButton(
          onPressed: () => {
            _getLocalImage(),
          },
          child: Text(
            'Tambah Gambar',
            style: GoogleFonts.openSans(color: Colors.white),
          ),
        ),
      ) : SizedBox(height:0),
        _buildNameField(),
        _buildCategoryField(),
        _buildStockField(),
        _buildExpirationDate(),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildSubingredientField(),
          ButtonTheme(
            child: ElevatedButton(
              child: Text('tambahkan', style: GoogleFonts.openSans(color: Colors.white, fontSize: 12.0)),
             onPressed: () => _addSubingredient(subingredientController.text),
            ),
          )
        ],
      ),
      GridView.count(
        childAspectRatio: MediaQuery.of(context).size.height / 600,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20),
        crossAxisCount: 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 3,
        children: _subingredients
            .map(
              (ingredient) => Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  ingredient,
                  style: GoogleFonts.openSans(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
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
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveInventory();
       //   Navigator.pop(context);

        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
