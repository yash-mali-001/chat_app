import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chitchat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase =
    FirebaseAuth.instance; // we Get the Firebase Object which we can use ahead

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;
  final _form = GlobalKey<
      FormState>(); // Checking Different States of Form  & its a global key
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  var _isAuthenticating = false;

  // ignore: non_constant_identifier_names
  void _submit() async {
    final isValid = _form.currentState!
        .validate(); //isValid is a boolean variable which ensures that entered values are as per our rules

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }
    _form.currentState!
        .save(); // if all inputs of form are valid then we sace the data.. //Also it triggers the onSaved Functn on TextFormFields5

    try {
      setState(() {
        _isAuthenticating = true;
      });

      // To check the mode i.e login or signup
      if (_isLogin) {
        // Logic to login the users
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        //Sign UP
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'imageUrl': imageUrl
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //...+
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? "Authentication Failed"),
        // ignore: use_build_context_synchronously
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      ));
      // setState(() {
      //   _isAuthenticating = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container for Profile Picture
            // Container(
            //   width: 200,
            //   margin: const EdgeInsets.only(right: 20, left: 30),
            //   child: Image.asset("assets/logo/logo.png"),
            //   decoration:
            //       BoxDecoration(borderRadius: BorderRadius.circular(40)),
            // ),
            CircleAvatar(
              child: Image.asset("assets/logo/chat-modified.png"),
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 100,
            ),
            // Card Widget For Showing Rectangular Place For Inputs
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Column will take only that much space which is needed for its content
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          const SizedBox(
                            height: 12,
                          ),

                          // To take Email input

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email Address",
                            ),
                            keyboardType: TextInputType
                                .emailAddress, // Keyboard Optimized for entering email id
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return "Enter a valid Email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),

                          // To take username input

                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Username",
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 6) {
                                  return "Enter a valid Username With minimum 6 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),

                          // To take password as input

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText:
                                true, //Enter values are not displayed .. For Security Purpose
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Enter a strong Password";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          // Button for Submitting the form
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: _isAuthenticating == true
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary),
                                          onPressed: _submit,
                                          child: Text(
                                              _isLogin ? "Log In" : "Sign Up")),
                                )
                              ]),

                          const SizedBox(
                            height: 12,
                          ),

                          // Text Button

                          _isAuthenticating == true
                              ? const CircularProgressIndicator()
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? "Create an Account "
                                      : "I already have an Account "))
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
