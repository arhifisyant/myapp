import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/model/user.dart';
import 'package:myapp/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  final MyUser _user = MyUser(password: '', email: '', displayName: '');

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
      //Navigator.push(context,
        //  MaterialPageRoute(builder: (context) => Feed()));
    } else {
      signup(_user, authNotifier);
    }
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Nama', prefixIcon: Icon(Icons.perm_identity)),
      keyboardType: TextInputType.text,
      style: GoogleFonts.openSans(fontSize: 20),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Nama wajib diisi';
        }

        if (value.length < 3 || value.length > 12) {
          return 'Nama minima 3 karakter ';
        }

        return null;
      },
      onSaved: (String? value) {
        _user.displayName = value;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Email',prefixIcon: Icon(Icons.email)),
      keyboardType: TextInputType.emailAddress,
      initialValue: 'dhila@gmail.com',
      style: GoogleFonts.openSans(fontSize: 18,),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email wajid diisi';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Masukkan email yang valid';
        }

        return null;
      },
      onSaved: (String? value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Kata Sandi',prefixIcon: Icon(Icons.password)),
      style: GoogleFonts.openSans(fontSize: 18),
      obscureText: true,
      controller: _passwordController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Password wajib diisi';
        }

        if (value.length < 5 || value.length > 20) {
          return 'Password harus lebih dari 5 karakter';
        }

        return null;
      },
      onSaved: (String? value) {
        _user.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Konfirmasi Kata Sandi',prefixIcon: Icon(Icons.password)),
      style: GoogleFonts.openSans
        (fontSize: 18),
      obscureText: true,
      validator: (String? value) {
        if (_passwordController.text != value) {
          return 'Kata Sandi Berbeda';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building login screen");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
              child: Column(
                children: <Widget>[
                  Image.asset('assets/logo.png'),
                  SizedBox(height: 20),
                  Text("Usaha Kesehatan Sekolah",style: GoogleFonts.openSans(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.blue),),
                  SizedBox(height: 32),
                  _authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                  SizedBox(height: 18),
                  _buildEmailField(),
                  SizedBox(height: 18),
                  _buildPasswordField(),
                  SizedBox(height: 18),
                  _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
                  SizedBox(height: 32),
                  ElevatedButton(
                   // padding: EdgeInsets.all(10.0),
                    onPressed: () => _submitForm(),
                    child: Text(
                      _authMode == AuthMode.Login ? 'Masuk' : 'Daftar',
                      style : GoogleFonts.openSans(fontSize: 14,fontWeight: FontWeight.w600),
                    ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent, //background color of button
                          side: BorderSide(width:1, color:Colors.white), //border width and color
                          elevation: 3, //elevation of button
                          fixedSize: const Size(250, 40),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(30)
                          ),
                      ),
                  ),
                  SizedBox(height: 7),
                  ElevatedButton(
                  //  padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Beralih ke ${_authMode == AuthMode.Login ? 'Daftar' : 'Masuk'}',
                      style: GoogleFonts.openSans(fontSize: 14,fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, //background color of button
                      side: BorderSide(width:1, color:Colors.white), //border width and color
                      elevation: 3, //elevation of button
                      fixedSize: const Size(250, 40),
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


const textInputDecoration = InputDecoration(
  //hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0)
  ),
);