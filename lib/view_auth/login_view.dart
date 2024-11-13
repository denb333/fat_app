import 'package:fat_app/Model/UserModel.dart';
import 'package:fat_app/service/UserService.dart';
import 'package:fat_app/view/Student/InteractLearningPage.dart';
import 'package:fat_app/view/Teacher/InteractLearningTeacherPage.dart';
import 'package:fat_app/view/loading/LoadingView.dart';
import 'package:fat_app/view_auth/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserService userService = new UserService();
  bool _isObscure3 = true;
  bool visible = false;
  Color customColor = Color(0xC3090808);
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final UserModel usermodel = new UserModel(
      userName: '',
      email: '',
      role: '',
      userClass: '',
      position: '',
      phoneNumber: '',
      createdCourses: [],
      profileImage: '');
  final _auth = FirebaseAuth.instance;

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
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(height: 20),
                        Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 40, right: 30),
                            child: Image.asset(
                              'images/img_login.png',
                              fit: BoxFit.cover,
                            )),
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
                        SizedBox(height: 30),
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
                                Icons.email,
                                color: customColor, // Set icon color
                              ),
                            ),
                            hintStyle: TextStyle(
                                color:
                                    customColor), // Ensure hint text is consistent
                            contentPadding: const EdgeInsets.only(
                                left: 14.0,
                                bottom: 15.0,
                                top:
                                    15.0), // Adjust content padding to align text
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // Changed to OutlineInputBorder for consistency
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
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
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
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
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
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
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          elevation: 5.0,
                          // width: 100,
                          height: 40,

                          onPressed: () {
                            setState(() {
                              visible = true;
                            });
                            // userService.signIn(_formkey, context,
                            //     emailController.text, passwordController.text);
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         LoadingView(duration: 3000),
                            //   ),
                            // );

                            // Assuming you already have the service and the method to sign in
                            userService
                                .signIn(_formkey, context, emailController.text,
                                    passwordController.text)
                                .then((user) {
                              setState(() {
                                visible = false;
                              });

                              print(
                                  "Login successful. User role: ${user.role}");
                              String role = user.role;
                              if (role == 'Teacher') {
                                // Navigate to the teacher's dashboard or page
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InteractLearningTeacherPage(),
                                  ),
                                );
                              } else if (role == 'Student') {
                                // Navigate to the student's page
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InteractLearningPage(),
                                  ),
                                );
                              } else {
                                // Handle invalid role or show an error
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid role')));
                              }
                            }).catchError((e) {
                              // Handle login failure (e.g., wrong password, email)
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login failed: $e')));
                            });
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.red,
                          minWidth: 180,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250, // Đặt độ rộng tại đây
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            elevation: 5.0,
                            height: 40,
                            onPressed: () async {
                              setState(() {
                                visible = true;
                              });
                              loginWithGoogle(context);
                            },
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/img_google.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Login with Google",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // SizedBox(
                        //   height: 20,
                        // ),

                        // Visibility(
                        //     maintainSize: true,
                        //     maintainAnimation: true,
                        //     maintainState: true,
                        //     visible: visible,
                        //     child: Container(
                        //         child: CircularProgressIndicator(
                        //           color: Colors.white,
                        //         ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              color: Colors.green, // Set background color to green
              width: MediaQuery.of(context).size.width,
              height: 30, // Set the height to match the image's layout
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Not registered yet? ", // Non-clickable text
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "Register here", // Clickable text
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
                                builder: (context) => Register(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loginWithGoogle(BuildContext context) async {
    try {
      // Bắt đầu quá trình đăng nhập với Google
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Nếu người dùng hủy đăng nhập, trả về và không làm gì cả
      if (googleUser == null) {
        print("User canceled the Google sign-in");
        return;
      }

      // Lấy thông tin xác thực của người dùng từ Google
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Tạo credential để đăng nhập vào Firebase
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập với Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // In ra tên người dùng sau khi đăng nhập thành công
      print("Đăng nhập thành công: ${userCredential.user?.displayName}");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoadingView(duration: 3000),
        ),
      );
      // Chuyển hướng sang HomePage sau khi đăng nhập thành công
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Đăng nhập thất bại: $e");

      // Có thể thông báo cho người dùng biết về lỗi (sử dụng Snackbar, Toast, v.v.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại: $e")),
      );
    }
  }
}
