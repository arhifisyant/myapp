import 'package:firebase_auth/firebase_auth.dart';
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

  final MyUser _user = MyUser(password: '', email: '', displayName: 'dhila');

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
      decoration: InputDecoration(labelText: "Display Name"),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 26),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Display Name is required';
        }

        if (value.length < 5 || value.length > 12) {
          return 'Display Name must be betweem 5 and 12 characters';
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
      decoration: InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      initialValue: 'dhila@gmail.com',
      style: TextStyle(fontSize: 26),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
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
      decoration: InputDecoration(labelText: "Password"),
      style: TextStyle(fontSize: 26),
      obscureText: true,
      controller: _passwordController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 5 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
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
      decoration: InputDecoration(labelText: "Confirm Password"),
      style: TextStyle(fontSize: 26),
      obscureText: true,
      validator: (String? value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building login screen");

    return Scaffold(
      body: Form(
        autovalidate: true,
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
            child: Column(
              children: <Widget>[
                Text(
                  "Please Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36),
                ),
                SizedBox(height: 32),
                _authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                _buildEmailField(),
                _buildPasswordField(),
                _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
                SizedBox(height: 32),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    setState(() {
                      _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                    });
                  },
                ),
                SizedBox(height: 16),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => _submitForm(),
                  child: Text(
                    _authMode == AuthMode.Login ? 'Login' : 'Signup',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}