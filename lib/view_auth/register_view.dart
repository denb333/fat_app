import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../service/UserService.dart';
import 'login_view.dart';
// import 'model.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;
  UserService userService = new UserService();

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  Color customColor = Color(0xC3090808);
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController username = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Student',
    'Teacher',
  ];
  var _currentItemSelected = "Student";
  var rool = "Student";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 40, right: 30),
                            child: Image.asset(
                              'images/img_login.png',
                              fit: BoxFit.cover,
                            )), // Logo at the top
                        // SizedBox(height: 20),
                        Text(
                          'WELCOME',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Login in your create account',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Username',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12), // Align the icon
                              child: Icon(
                                Icons.account_circle,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Username cannot be empty";
                            }
                          },
                          onChanged: (value) {},
                          // keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12), // Align the icon
                              child: Icon(
                                Icons.mail,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12), // Align the icon
                              child: Icon(
                                Icons.lock,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            enabled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12), // Align the icon
                              child: Icon(
                                Icons.lock,
                                color: customColor, // Set icon color
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 15.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (confirmpassController.text !=
                                passwordController.text) {
                              return "Password did not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Other widgets (e.g. Text)

                            Padding(
                              padding: EdgeInsets.only(
                                  left: 6.0), // Add padding to the left
                              child: SizedBox(
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Set background color to white
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the border radius
                                  ),
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    isDense: true,
                                    isExpanded: false,
                                    iconEnabledColor: Colors.white,
                                    focusColor: Colors.white,
                                    items: options
                                        .map((String dropDownStringItem) {
                                      return DropdownMenuItem<String>(
                                        value: dropDownStringItem,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // Centers the Row content
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_drop_down, // You can change this to any icon
                                              color: Colors.black,
                                            ),
                                            Text(
                                              dropDownStringItem,
                                              style: TextStyle(
                                                color: Colors.black,
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValueSelected) {
                                      setState(() {
                                        _currentItemSelected =
                                            newValueSelected!;
                                        rool = newValueSelected;
                                      });
                                    },
                                    value: _currentItemSelected,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                setState(() {
                                  showProgress = true;
                                });
                                userService.signUp(
                                    _formkey,
                                    username.text,
                                    emailController.text,
                                    passwordController.text,
                                    rool,
                                    context);
                                Navigator.of(context).pushNamed('/emailverify');
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color:
                                  Colors.green, // Set background color to green
                              width: MediaQuery.of(context).size.width,
                              height:
                                  30, // Set the height to match the image's layout
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Already have account? ", // Non-clickable text
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Login", // Clickable text
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          // decoration: TextDecoration.underline, // Optional underline effect
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to the Register screen when clicked
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
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
    );
  }
}
