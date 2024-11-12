// list_lecture_page.dart
import 'package:fat_app/view/Student/QuizPage.dart';
import 'package:flutter/material.dart';
import 'package:fat_app/view/Student/videoplayerPage.dart';

class ListLecturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khóa Học Toán Lớp 8"),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ChapterTile(
            chapterName: "Chương 1: Phép nhân và phép chia các đa thức",
            lessons: [
              LessonTile(
                lessonName: "1. Phân thức đại số",
                description: "Học cách phân tích và giải quyết phân thức.",
                videoUrl: "https://www.youtube.com/watch?v=sfXowmg886A&t=10s",
                lessonId: "lesson_1_1",
              ),
              LessonTile(
                lessonName: "2. Nhân đa thức với đa thức",
                description: "Áp dụng quy tắc nhân cho đa thức.",
                videoUrl: "https://www.youtube.com/watch?v=RctDUQY1GIU",
                lessonId: "lesson_1_2",
              ),
            ],
          ),
          // Các chương khác
        ],
      ),
    );
  }
}

class ChapterTile extends StatelessWidget {
  final String chapterName;
  final List<LessonTile> lessons;

  ChapterTile({required this.chapterName, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          chapterName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.blue,
          ),
        ),
        children: lessons,
      ),
    );
  }
}

class LessonTile extends StatelessWidget {
  final String lessonName;
  final String description;
  final String videoUrl;
  final String lessonId;

  LessonTile({
    required this.lessonName,
    required this.description,
    required this.videoUrl,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Text(
        lessonName,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
      subtitle: Text(
        description,
        style: TextStyle(color: Colors.grey[700], fontSize: 14.0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.video_label, color: Colors.blueAccent),
            tooltip: 'Xem video',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.quiz, color: Colors.green),
            tooltip: 'Làm bài tập',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizPage(lessonId: lessonId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
