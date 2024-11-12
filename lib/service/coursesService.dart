import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/Model/lecture.dart';

class LectureService {
  final CollectionReference _lectureCollection =
      FirebaseFirestore.instance.collection('Lectures');

  Future<bool> checkLectureExists(String lectureId) async {
    try {
      DocumentSnapshot snapshot = await _lectureCollection.doc(lectureId).get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking lecture exist: $e');
      return false;
    }
  }

  Future<List<Lecture>> getLectures() async {
    try {
      QuerySnapshot snapshot = await _lectureCollection.get();
      return snapshot.docs
          .map((doc) => Lecture.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching lectures: $e');
      throw e;
    }
  }

  Future<void> updateLecture(String lectureId, Lecture lecture) async {
    try {
      final lectureData = lecture.toMap();
      if (lectureData != null) {
        await _lectureCollection.doc(lectureId).update(lectureData);
        print('Chapter Name: ${lecture.chaptername}');
        print('Lecture Name:${lecture.lecturename}');
        print('Lecture Description: ${lecture.description}');
        print('Lecture Date: ${lecture.date}');
      } else {
        print('Error: Lecture data is null');
      }
    } catch (e) {
      print('Error updating lecture: $e');
    }
  }
}
