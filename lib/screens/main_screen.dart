import 'dart:io';
import 'package:chatrefer/add_image/add_image.dart';


import 'package:flutter/material.dart';
import 'package:chatrefer/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart'; //for user authentication
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart'; //for showing that app is operating
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance; // authentication instance
  bool isSignupScreen = true;
  bool showSpinner = false;
  bool isuserNamevalid = true;
  bool ishouseNumbervalid = true;


  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String houseNumber = '';
  String userPassword = '';
  File? userPickedImage;

  //final url = 'https://otherhome.com.au/';

  void pickedImage(File image) {
    userPickedImage = image;
  }

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: AddImage(pickedImage),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('image/green2.jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 90, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Welcome',
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: isSignupScreen
                                        ? ' to Otherhome! 🏠'
                                        : ' back! 👍',
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      fontSize: 25,
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            isSignupScreen
                                ? 'Signup to continue'
                                : 'Signin to continue',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), // for background
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  top: 180,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    padding: EdgeInsets.all(20.0),
                    height: isSignupScreen ? 320.0 : 280.0,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          )
                        ]),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1,
                                      ),
                                    ),
                                    if (!isSignupScreen) //inline if statement
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 85,
                                        color: Colors.green,
                                      )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSignupScreen
                                                ? Palette.activeColor
                                                : Palette.textColor1,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        if (isSignupScreen)
                                          Container(
                                            margin: EdgeInsets.only(bottom: 1),
                                            child: GestureDetector(
                                              onTap: () {
                                                showAlert(context);
                                              },
                                              child: Icon(
                                                Icons.image,
                                                size: 20.5,
                                                color: isSignupScreen
                                                    ? Colors.lightGreen
                                                    : Colors.grey[300],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                    if (isSignupScreen) //inline if statement
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 3, 3, 0),
                                        height: 2,
                                        width: 85,
                                        color: Colors.green,
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (isSignupScreen)
                            SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        key: ValueKey(0),
                                        // state가 엉키는 문제 해결
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 2) {
                                            isuserNamevalid = false;
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            userName = '';
                                            return 'Please enter at least 2 characters';
                                          }
                                          isuserNamevalid = true;
                                        },
                                        onSaved: (value) {
                                          if (isuserNamevalid) {
                                            userName = value!;
                                          }
                                        },
                                        onChanged: (value) {
                                          if (!isuserNamevalid) {
                                            setState(() {
                                              isuserNamevalid = true;
                                            });
                                            userName = value;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: Colors.lightGreen,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          hintText: 'User name',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lightGreen,
                                          ),
                                          contentPadding: EdgeInsets.all(
                                              10), //padding for textform
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        key: ValueKey(1),
                                        // state가 엉키는 문제 해결
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              int.tryParse(value) == null) {
                                            ishouseNumbervalid = false;
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            houseNumber = '';
                                            return 'Please enter invalid House number';
                                          }
                                          ishouseNumbervalid = true;
                                        },
                                        onSaved: (value) {
                                          if (ishouseNumbervalid) {
                                            houseNumber = value!;
                                          }
                                        },
                                        onChanged: (value) {
                                          if (!ishouseNumbervalid) {
                                            houseNumber = value;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.house,
                                            color: Colors.lightGreen,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          hintText: 'House number',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lightGreen,
                                          ),
                                          contentPadding: EdgeInsets.all(
                                              10), //padding for textform
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // email용 키보드로 바꾸는 method
                                        key: ValueKey(2),
                                        // state가 엉키는 문제 해결
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userEmail = value!;
                                        },
                                        onChanged: (value) {
                                          userEmail = value;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.lightGreen,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lightGreen,
                                          ),
                                          contentPadding: EdgeInsets.all(
                                              10), //padding for textform
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        // hiding password method
                                        key: ValueKey(3),
                                        // state가 엉키는 문제 해결
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 6) {
                                            return 'Password must be at least 7 characters long.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userPassword = value!;
                                        },
                                        onChanged: (value) {
                                          userPassword = value;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.lightGreen,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lightGreen,
                                          ),
                                          contentPadding: EdgeInsets.all(
                                              10), //padding for textform
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (!isSignupScreen) // inline if statement
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      key: ValueKey(4),
                                      // state가 엉키는 문제 해결
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      onChanged: (value) {
                                        userEmail = value;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.lightGreen,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightGreen),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightGreen),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.lightGreen,
                                        ),
                                        contentPadding: EdgeInsets.all(
                                            10), //padding for textform
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      key: ValueKey(5),
                                      // state가 엉키는 문제 해결
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 6) {
                                          return 'Password must be at least 7 characters long.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      onChanged: (value) {
                                        userPassword = value;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.lightGreen,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightGreen),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightGreen),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.lightGreen,
                                        ),
                                        contentPadding: EdgeInsets.all(
                                            10), //padding for textform
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ), // for text form filed
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  top: isSignupScreen ? 462.5 : 415,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: GestureDetector(
                        // 터치에 반응하는 위젯
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if (isSignupScreen) {
                            if (userPickedImage == null) {
                              setState(() {
                                showSpinner = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Please pick your image'),
                                backgroundColor: Colors.green,
                              ));
                              return;
                            }
                            _tryValidation();

                            if (userName == '' ||
                                userEmail == '' ||
                                houseNumber == '') {
                              setState(() {
                                showSpinner = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Something wrong! Please check your details'),
                                backgroundColor: Colors.lightGreen,
                              ));
                            }

                            try {
                              if (userName == '' ||
                                  userEmail == '' ||
                                  houseNumber == '') {
                                return;
                              }
                              final newUser = await _authentication
                                  .createUserWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                              );

                              final refImage = FirebaseStorage.instance
                                  .ref()
                                  .child('profile_picture')
                                  .child(newUser.user!.uid + 'png');
                              //to store picked profile picture into firebase storage

                              await refImage.putFile(userPickedImage!);
                              final url = await refImage.getDownloadURL();

                              if (userName == '' ||
                                  userEmail == '' ||
                                  houseNumber == '') {
                                return;
                              }

                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(newUser.user!.uid)
                                  .set({
                                'userName': userName,
                                'email': userEmail,
                                'houseNumber': houseNumber,
                                'profilePicture': url
                              });

                              if (newUser.user != null) {
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);

                              setState(() {
                                showSpinner = false;
                              });

                              if (mounted)
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Please check your email and password'),
                                  backgroundColor: Colors.lightGreen,
                                ));
                            }
                          }
                          if (!isSignupScreen) {
                            _tryValidation();

                            try {
                              final newUser = await _authentication
                                  .signInWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                              );
                              if (newUser.user != null) {
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                              setState(() {
                                showSpinner = false;
                              });

                              if (mounted)
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Please check your email and password'),
                                  backgroundColor: Colors.lightGreen,
                                ));
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.lightGreenAccent,
                                  Colors.green,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ), // for send button
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  top: isSignupScreen
                      ? MediaQuery.of(context).size.height - 125
                      : MediaQuery.of(context).size.height - 135,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Text(isSignupScreen
                          ? 'Nice to meet you!!'
                          : 'Welcome back!!'),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton.icon(
                        onPressed: (){},
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(155, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.lightGreen,
                        ),
                        icon: Icon(Icons.house),
                        label: Text('To website'),
                      ),
                    ],
                  ),
                ), //google login button
              ],
            ),
          ),
        ));
  }
}
