import 'package:fat_app/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:fat_app/Model/courses.dart';

class TutorDetailPage extends StatefulWidget {
  final Course course;
  final UserModel user;

  const TutorDetailPage({Key? key, required this.course, required this.user})
      : super(key: key);

  @override
  State<TutorDetailPage> createState() => _TutorDetailPageState();
}

class _TutorDetailPageState extends State<TutorDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.userName),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Add share functionality
            },
          ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite; // Toggle trạng thái yêu thích
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Thêm SingleChildScrollView để tránh overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                // Căn giữa avatar
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage('assets/tutor_avatar.jpg'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Giáo viên: ${widget.course.teacher}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Môn học: ${widget.course.subject}',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Chức vụ: ${widget.user.position}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'Mô tả: ${widget.course.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Time: ${widget.course.startTime} - ${widget.course.endTime}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      // Add enrollment functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/chat');
                      },
                      child: const Text(
                        'Inbox',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '4.5/5', // Thêm rating cứng
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Add review functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Viết đánh giá',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
