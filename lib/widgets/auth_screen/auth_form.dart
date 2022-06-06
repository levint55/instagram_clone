import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLogin = true;
  String? _username;
  String? _email;
  String? _password;
  String? _confirmPassword;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  void _trySubmit() async {
    _formKey.currentState?.save();
    final isValid = _formKey.currentState?.validate();
    UserCredential authResult;

    try {
      if (isValid == null) {
        return;
      }

      if (isValid) {
        if (_isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: _email ?? '', password: _password ?? '');
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: _email ?? '', password: _confirmPassword ?? '');

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user?.uid)
              .set({
            'username': _username,
            'email': _email,
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('username'),
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null) {
                  return 'Username is null';
                }
                if (value.isEmpty) {
                  return 'Username can not be empty';
                }
                if (value.length < 4) {
                  return 'Username at least 4 characters';
                }
                return null;
              },
              onSaved: (value) {
                _username = value;
              },
            ),
          TextFormField(
            key: const ValueKey('email'),
            decoration: const InputDecoration(labelText: 'Email address'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null) {
                return 'Email is null';
              }
              if (value.isEmpty) {
                return 'Email can not be empty';
              }
              if (!value.contains('@')) {
                return 'Email invalid';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          TextFormField(
            key: const ValueKey('password'),
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null) {
                return 'Password is empty';
              }
              if (value.isEmpty) {
                return 'Password can not be empty';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('confirmPassword'),
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value == null) {
                  return 'Confirm password is null';
                }
                if (value.isEmpty) {
                  return 'Confirm password can not be empty';
                }
                if (value != _confirmPassword) {
                  return 'Confirm password not same';
                }
                return null;
              },
              onSaved: (value) {
                _confirmPassword = value;
              },
            ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: _trySubmit,
              child: Text(_isLogin ? 'Login' : 'Register')),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: Text(_isLogin
                ? 'Dont have an account?'
                : 'Already have an account?'),
          )
        ],
      ),
    );
  }
}
