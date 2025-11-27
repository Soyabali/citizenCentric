import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/user_image_picker.dart';


final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {

  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  var _isAuthenticating = false;
  var  userCredentials ;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      // show error message ...
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
         userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

         print("------49---$userCredentials");

      } else {
         userCredentials = await _firebase.createUserWithEmailAndPassword(
             email: _enteredEmail, password: _enteredPassword);
         // todo this is storage code on a firebase

         try {
           final storageRef = FirebaseStorage.instance
               .ref()
               .child('user_images')
               .child('${userCredentials.user!.uid}.jpg');

           print("Uploading file: ${_selectedImage?.path}");
           print("Upload path: user_images/${userCredentials.user!.uid}.jpg");

           // Upload image
           final uploadTask = await storageRef.putFile(_selectedImage!);

           // Check upload success
           final snapshot = uploadTask;

           if (snapshot.state == TaskState.success) {
             final imageUrl = await storageRef.getDownloadURL();
             print("Image uploaded: $imageUrl");

             // Store data inside Firestore
             await FirebaseFirestore.instance
                 .collection('users')
                 .doc(userCredentials.user!.uid)
                 .set({
               'username': _enteredUsername,
               'email': _enteredEmail,

               'image_url': imageUrl,
             });

             print("User document saved successfully!");
           } else {
             print("Upload failed!");
           }
         } catch (e) {
           print("ERROR uploading: $e");
         }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
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
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                }),
                          SizedBox(height: 10),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}// // ignore_for_file: depend_on_referenced_packages



// import 'dart:io';

// import 'package:chat_application/widgets/user_image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// final _firebase = FirebaseAuth.instance;

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() {
//     return _AuthScreenState();
//   }
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final _form = GlobalKey<FormState>();
//   var _isLogin = true;
//   var _enteredEmail = '';
//   var _enteredPassword = '';
//   File? _selectedImage;
//   var _isAuthenticating = false;

//   void _submit() async {
//     final isValid = _form.currentState!.validate();

//     if (!isValid || !_isLogin && _selectedImage == null) {
//       // show a message
//       return;
//     }

//     _form.currentState!.save();

//     try {
//       setState(() {
//         _isAuthenticating = true;
//       });
//       if (_isLogin) {
//         final userCredentials = await _firebase.signInWithEmailAndPassword(
//             email: _enteredEmail, password: _enteredPassword);
//       } else {
//         final userCredentials = await _firebase.createUserWithEmailAndPassword(
//             email: _enteredEmail, password: _enteredPassword);
//         // image store on firebase code
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('user_images')
//             .child('${userCredentials.user!.uid}.jpg');

//         await storageRef.putFile(_selectedImage!);
//         final imageUrl = await storageRef.getDownloadURL();
//         print('---Downlode --54--$imageUrl');
//       }
//     } on FirebaseAuthException catch (error) {
//       if (error.code == 'email-already-in-use') {
//         // ...
//       }
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(error.message ?? 'Authentication failed.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(
//                   top: 30,
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                 ),
//                 width: 200,
//                 child: Image.asset('assets/images/chat.png'),
//               ),
//               Card(
//                 margin: const EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Form(
//                       key: _form,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (!_isLogin)
//                             UserImagePicker(
//                               onPickImage: ((pickedImage) {
//                                 _selectedImage = pickedImage;
//                               }),
//                             ),
//                           TextFormField(
//                             decoration: const InputDecoration(
//                                 labelText: 'Email Address'),
//                             keyboardType: TextInputType.emailAddress,
//                             autocorrect: false,
//                             textCapitalization: TextCapitalization.none,
//                             validator: (value) {
//                               if (value == null ||
//                                   value.trim().isEmpty ||
//                                   !value.contains('@')) {
//                                 return 'Please enter a valid email address.';
//                               }

//                               return null;
//                             },
//                             onSaved: (value) {
//                               _enteredEmail = value!;
//                             },
//                           ),
//                           TextFormField(
//                             decoration:
//                                 const InputDecoration(labelText: 'Password'),
//                             obscureText: true,
//                             validator: (value) {
//                               if (value == null || value.trim().length < 6) {
//                                 return 'Password must be at least 6 characters long.';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _enteredPassword = value!;
//                             },
//                           ),
//                           const SizedBox(height: 12),
//                           if (_isAuthenticating)
//                             const CircularProgressIndicator(),
//                           if (!_isAuthenticating)
//                             ElevatedButton(
//                               onPressed: _submit,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Theme.of(context)
//                                     .colorScheme
//                                     .primaryContainer,
//                               ),
//                               child: Text(_isLogin ? 'Login' : 'Signup'),
//                             ),
//                           if (!_isAuthenticating)
//                             TextButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _isLogin =
//                                       !_isLogin; // logic to change login state
//                                 });
//                               },
//                               child: Text(_isLogin
//                                   ? 'Create an account'
//                                   : 'I already have an account'),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
