import 'package:fat_app/Model/chapter.dart';
import 'package:fat_app/Model/courses.dart';
import 'package:fat_app/Model/lesson.dart';
import 'package:fat_app/service/chapterService.dart';
import 'package:fat_app/view/Student/quizPage.dart';
import 'package:fat_app/view/Teacher/TeacherScreen.dart';
import 'package:flutter/material.dart';

class LectureListScreen extends StatelessWidget {
  final ChapterService _chapterService = ChapterService();
  final List<int> chapterId;
  final Course course;

  LectureListScreen({
    Key? key,
    required this.chapterId,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Received chapterId: $chapterId");
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildChapterList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(course.subject),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Add chapter action here
          },
          tooltip: 'Add Chapter',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement watch functionality
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Watch'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // TODO: Implement notifications
          },
        ),
      ],
    );
  }

  Widget _buildChapterList() {
    return StreamBuilder<List<Chapter>>(
      stream: _chapterService.getChaptersForCourse(chapterId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading chapters'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No chapters available'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Chapter'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ChapterTile(
              chapter: snapshot.data![index],
              chapterService: _chapterService,
              course: course,
              lessonId: chapterId,
            );
          },
        );
      },
    );
  }
}

class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final ChapterService chapterService;
  final Course course;
  final List<int> lessonId;

  const ChapterTile({
    Key? key,
    required this.chapter,
    required this.chapterService,
    required this.course,
    required this.lessonId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: Text(
            "Chapter ${chapter.chapterId}: ${chapter.chapterName}",
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          children: [
            _buildLessonList(),
            // Add Lesson Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ),
                    //   ),
                    //   );
                  },
                  tooltip: 'Add Lesson',
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildLessonList() {
    return StreamBuilder<List<Lesson>>(
      stream: chapterService.getLessonsForChapters(lessonId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ListTile(title: Text('Error loading lessons'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const ListTile(title: Text('No lessons available'));
        }

        return Column(
          children: snapshot.data!
              .map((lesson) => LessonTile(lesson: lesson))
              .toList(),
        );
      },
    );
  }
}

class LessonTile extends StatelessWidget {
  final Lesson lesson;

  const LessonTile({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32.0),
      title: Text(
        "${lesson.lessonName}",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        lesson.description,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.video_library_outlined, size: 20),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      TeacherScreen(lessonId: lesson.lesson_ID)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.quiz_outlined, size: 20),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    QuizPage(lessonId: lesson.lesson_ID.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
