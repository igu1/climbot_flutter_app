// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print, depend_on_referenced_packages, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  late String _email;

  late String _password;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  // This method signs in a user with Google and returns their Firebase user object
  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to get the currently authenticated user without prompting the user
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signInSilently();
      // Get the authentication credentials for the user
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              // ignore: prefer_const_literals_to_create_immutables
              ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        // ignore: sort_child_properties_last
                        child: Text(
                          'Hey,\nWelcome Back!',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        margin: EdgeInsets.only(top: 100, left: 40),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            width: 100,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 150,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 45, top: 5),
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                color: Colors.grey.shade700.withOpacity(0.8))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Logging In'),
                            ));
                            try {
                              UserCredential userCredential =
                                  await _auth.signInWithEmailAndPassword(
                                email: _email,
                                password: _password,
                              );
                              User? user = userCredential.user;
                              print('Signed in user: $user');
                              Navigator.pushReplacementNamed(context, 'home');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            } catch (e) {
                              print('Error signing in: $e');
                            }
                          }
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // ignore: prefer_const_literals_to_create_immutables
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(255, 199, 0, 1),
                                Color.fromARGB(255, 254, 204, 22),
                                Color.fromARGB(255, 252, 209, 56),
                                Color.fromARGB(255, 246, 229, 41)
                              ])),
                          child: Center(
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'register');
                  },
                  child: Container(
                    child: Text("Dont have an account? "),
                  ),
                ),
                SizedBox(height: 80),
                GestureDetector(
                  onTap: () async {
                    User? user = await signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      print('Error signing in: $user');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                        // ignore: prefer_const_literals_to_create_immutables
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 250, 250, 250),
                          Color.fromARGB(255, 202, 225, 243),
                        ]),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            // decoration: BoxDecoration(color: Colors.blue),
                            child: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover,
                        )),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Log-in with Google')
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
