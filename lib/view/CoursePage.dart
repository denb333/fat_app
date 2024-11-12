import 'package:fat_app/view/Teacher/addCoursesScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fat_app/view/widgets/search_bar.dart';
import 'package:fat_app/view/widgets/subject_chips.dart';
import 'package:fat_app/view/widgets/custom_app_bar.dart';
import 'package:fat_app/view/widgets/custom_bottom_navigation_bar.dart';

import '../Model/courses.dart';

// Import AddCoursesScreen

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  _CoursePage createState() => _CoursePage();
}

class _CoursePage extends State<CoursePage> {
  String username = 'Trần Đức Vũ';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Course> courses = [];
  List<String> registeredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _fetchRegisteredCourses();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        username = user.displayName ?? '';
      });
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final result = await _firestore.collection('Courses').get();
      setState(() {
        courses =
            result.docs.map((doc) => Course.fromDocumentSnapshot(doc)).toList();
      });
    } catch (e) {
      print('Failed to fetch courses: $e');
    }
  }

  Future<void> _fetchRegisteredCourses() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        setState(() {
          registeredCourses =
              List<String>.from(userDoc.data()?['registeredCourses'] ?? []);
        });
      } catch (e) {
        print('Failed to fetch registered courses: $e');
      }
    }
  }

  Future<void> _registerCourse(String courseId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('Users').doc(user.uid).update({
          'registeredCourses': FieldValue.arrayUnion([courseId]),
        });
        _fetchRegisteredCourses();
      } catch (e) {
        print('Failed to register course: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        username: username,
        onAvatarTap: () {
          Navigator.of(context).pushNamed('/updateinformation');
        },
        onNotificationTap: () {},
      ),
      body: Column(
        children: [
          // Search bar and subject chips
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchBarWidget(
                  onSearch: (query) {
                    // Handle search logic
                    print("Search query: $query");
                  },
                ),
                const SizedBox(height: 12.0),
                SubjectChipsWidget(subjects: [
                  'Chemistry',
                  'Physics',
                  'Math',
                  'Geography',
                  'History',
                ]),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.lightBlue.shade100,
            padding: const EdgeInsets.all(16.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Schedule Courses',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
          ),
          // Expanded(
          //   child: GridView.count(
          //     crossAxisCount: 2,
          //     padding: const EdgeInsets.all(16.0),
          //     crossAxisSpacing: 16.0,
          //     mainAxisSpacing: 16.0,
          //     childAspectRatio: 0.7,
          //     children: courses.map((course) {
          //       bool isRegistered = registeredCourses.contains(course.id);
          //       return _buildClassCard(
          //           course.subject,
          //           course.teacher,
          //           '${course.startDate} - ${course.endDate}',
          //           course.price,
          //           course.description,
          //           isRegistered,
          //           course.id);
          //     }).toList(),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddCoursesScreen page
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddCoursesScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/interactlearning');
              break;
            case 1:
              Navigator.of(context).pushNamed('/classschedule');
              break;
            case 2:
              Navigator.of(context).pushNamed('/course');
              break;
            case 3:
              Navigator.of(context).pushNamed('/chat');
              break;
            case 4:
              Navigator.of(context).pushNamed('/findatutor');
              break;
          }
        },
      ),
    );
  }

  Widget _buildClassCard(
    String subject,
    String teacher,
    String time,
    double price,
    String description,
    bool isRegistered,
    String courseId,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.green.shade50,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section with subject and teacher
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          teacher,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time section
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            time,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description section
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Action button
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: isRegistered
                          ? ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/listlecture', arguments: {
                                  'courseId': courseId,
                                });
                              },
                              icon: const Icon(Icons.play_circle_outline),
                              label: const Text('Join Course'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                _showConfirmationDialog(
                                    context, price, courseId, subject);
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label:
                                  Text('Buy for \$${price.toStringAsFixed(2)}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, double price, String courseId, subject) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Purchase'),
            content: Text("Bạn xác nhận mua khóa học với giá \$$price?"),
            actions: <Widget>[
              TextButton(
                  child: Text("Không"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                child: Text('Có'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _registerCourse(courseId);
                  Navigator.of(context).pushNamed('/payment', arguments: {
                    'price': price,
                    'courseId': courseId,
                    'subject': subject,
                    'username': username,
                  });
                },
              ),
            ],
          );
        });
  }
}
