import 'package:fat_app/view/Student/listlecturePage.dart';
import 'package:fat_app/view/Student/tutorlistPage.dart';
import 'package:fat_app/view/payment/confirmmethodScreen.dart';
import 'package:fat_app/view_auth/login_view.dart';
import 'package:fat_app/view_auth/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fat_app/view/Teacher/TeacherScreen.dart';
import 'package:fat_app/view/UpdateInformationPage.dart';
import 'package:fat_app/view_auth/EmailVerify.dart';
import 'package:fat_app/view/liveStreamPage.dart';
import 'package:fat_app/view/ClassSchedulePage.dart';
import 'package:fat_app/view/CoursePage.dart';
import 'package:fat_app/view/InteractLearningPage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'constants/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase với cấu hình tùy thuộc vào nền tảng
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCiwggXPtUAGNoyweoUyrfYRgv2fx2GrGw",
        authDomain: "study-86d58.firebaseapp.com",
        projectId: "study-86d58",
        storageBucket: "study-86d58.appspot.com",
        messagingSenderId: "988979923331",
        appId: "1:988979923331:web:01192e3ea977b9cdf0ceb6",
        measurementId: "G-7748LM21HT",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        livestreampage: (context) => LiveStreamPage(),
        classschedulePage: (context) => const ClassSchedulePage(),
        coursepage: (context) => const CoursePage(),
        fatutorpage: (context) => const TutorListPage(),
        interactlearningpage: (context) => const InteractLearningPage(),
        loginRoutes: (context) => LoginPage(),
        registerRoutes: (context) => Register(),
        emailverifyRoute: (context) => const EmailVerify(),
        paymentRoutes: (context) => PaymentMethodScreen(),
        updateinformationRoutes: (context) => UpdateInformationPage(),
        listlectureRoutes: (context) => ListLecturePage(),
        teacherliverecord: (context) => TeacherScreen(),
        // teacherlive: (context) => TeacherScreenLive(cameras: cameras!),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.green,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/factutor_logo.png',
                  height: 80,
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/logo.png'),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset('images/students.png'),
                        const SizedBox(height: 5),
                        const Text('Students'),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoutes, (route) => false);
                          },
                          child: const Text('Join Class'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 100),
                    Column(
                      children: [
                        Image.asset('images/tutor.png', height: 50),
                        const SizedBox(height: 5),
                        const Text('Tutor'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                interactlearningpage, (route) => false);
                          },
                          child: const Text('Join Class'),
                        ),
                      ],
                    )
                  ],
                ),
                // SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Handle Facebook sign up
                      try {
                        final LoginResult result =
                        await FacebookAuth.instance.login();
                        if (result.status == LoginStatus.success) {
                          final userData =
                          await FacebookAuth.instance.getUserData();
                          print(userData);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoutes, (route) => false);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to sign up with Facebook'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.facebook),
                    label: const Text('Continue with Facebook'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            'LEARN WITH TUTOR',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
