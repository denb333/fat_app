import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String teacher;
  final String startTime;
  final String endTime;
  final double price;
  final String subject;
  final String description;
  final String creatorId;

  Course({
    required this.id,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.subject,
    required this.description,
    required this.creatorId,
  });

  factory Course.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      teacher: data['teacher'] ?? 'Unknown Teacher',
      startTime: data['startTime'] ?? 'N/A',
      endTime: data['endTime'] ?? 'N/A',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      subject: data['subject'] ?? 'No description',
      description: data['description'] ?? 'No description',
      creatorId: data['ID_created'] ?? '',
    );
  }
}
