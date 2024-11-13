// lib/services/chapter_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/Model/chapter.dart';
import 'package:fat_app/Model/lesson.dart';

class ChapterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Chapter>> getChapters() {
    return _firestore
        .collection('chapter')
        .orderBy('chapterId') // Added ordering
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chapter.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Stream<List<Chapter>> getChaptersForCourse(List<int> chapterIds) {
    print('Fetching chapters for course: $chapterIds'); // Log chapterIds
    return _firestore
        .collection('chapter')
        .where('chapterId',
            whereIn:
                chapterIds) // Dùng whereIn để so sánh nhiều giá trị chapterId
        .orderBy('chapterId')
        .snapshots()
        .map((snapshot) {
      print(
          'Received snapshot with ${snapshot.docs.length} docs'); // Log số lượng tài liệu nhận được
      return snapshot.docs.map((doc) {
        var data = doc.data();
        print('Document data: $data'); // Log dữ liệu tài liệu
        return Chapter.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }

  Stream<List<Lesson>> getLessonsForChapters(List<int> lessonIds) {
    print('Fetching lessons for chapter: $lessonIds'); // Log lessonIds
    return _firestore
        .collection('lesson')
        .where('lesson_ID', whereIn: lessonIds)
        .orderBy('lesson_ID')
        .snapshots()
        .map((snapshot) {
      print('Received snapshot with ${snapshot.docs.length} docs');
      return snapshot.docs.map((doc) {
        var data = doc.data();
        print('Document data: $data');
        return Lesson.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }

  Future<void> addChapter(Chapter chapter) =>
      _firestore.collection('chapter').add(chapter.toMap());

  Future<void> addLesson(Lesson lesson) =>
      _firestore.collection('lesson').add(lesson.toMap());

  Future<void> updateChapter(String docId, Chapter chapter) =>
      _firestore.collection('chapter').doc(docId).update(chapter.toMap());

  Future<void> updateLesson(String docId, Lesson lesson) =>
      _firestore.collection('lesson').doc(docId).update(lesson.toMap());

  Future<void> deleteChapter(String docId) =>
      _firestore.collection('chapter').doc(docId).delete();

  Future<void> deleteLesson(String docId) =>
      _firestore.collection('lesson').doc(docId).delete();
}
