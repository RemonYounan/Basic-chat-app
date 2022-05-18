import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chat/widgets/auth/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm({
    required this.submitFn,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  bool isLoading;

  final void Function(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _userName = '';
  var _password = '';
  File? _image;

  void _pickImage(File image) {
    _image = image;
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_image == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _email.trim(),
        _password.trim(),
        _userName.trim(),
        _image == null ? null : _image!,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      errorStyle: TextStyle(
                        fontSize: 12,
                      ),
                      // errorBorder: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Enter A valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        errorStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please Enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      errorStyle: TextStyle(
                        fontSize: 12,
                      ),
                      // errorBorder: InputBorder.none,
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  // confirm Password :
                  // AnimatedContainer(
                  //   duration: const Duration(milliseconds: 300),
                  //   // curve: Curves.easeIn,
                  //   constraints: BoxConstraints(
                  //       minHeight: !_isLogin ? 60 : 0,
                  //       maxHeight: !_isLogin ? 120 : 0),
                  //   child: TextFormField(
                  //     key: const ValueKey('confirmPassword'),
                  //     decoration:
                  //         const InputDecoration(labelText: 'Confirm Password'),
                  //     obscureText: true,
                  //     textInputAction: TextInputAction.done,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create New Account'
                            : 'I already have an account',
                        style: const TextStyle(fontSize: 14),
                      ),
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
