// lib/services/course_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/Model/courses.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveCourse(Course course) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Create a new course ID
        String courseId = _firestore.collection('Courses').doc().id;
        // Save the course data to Firestore
        await _firestore
            .collection('Courses')
            .doc(courseId)
            .set(course.toJson());
      } catch (e) {
        throw Exception('Failed to add course: $e');
      }
    } else {
      throw Exception('No authenticated user found');
    }
  }
}
