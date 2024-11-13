import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/view/widgets/custom_bottom_navigation_bar.dart';
import 'package:fat_app/view/widgets/custom_teacher_app_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InteractLearningTeacherPage extends StatefulWidget {
  const InteractLearningTeacherPage({Key? key}) : super(key: key);

  @override
  _InteractLearningPageState createState() => _InteractLearningPageState();
}

class _InteractLearningPageState extends State<InteractLearningTeacherPage> {
  String username = '';
  int currentIndex = 0;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            username = doc.get('username') as String? ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSearchSection(),
          const SizedBox(height: 24),
          _buildFeatureGrid(),
          const SizedBox(height: 24),
          _buildScheduleCard(),
          const SizedBox(height: 24),
          _buildGroupClasses(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : 'S',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                username.isNotEmpty ? username : 'Teacher',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search TextField
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for tutors, subjects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            // Subject Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Chemistry',
                'Physics',
                'Math',
                'Geography',
                'History',
              ].map((subject) => _buildSubjectChip(subject)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChip(String subject) {
    return Material(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            subject,
            style: TextStyle(color: Colors.blue[700]),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'icon': Icons.person_search,
        'title': 'Find a tutor',
        'color': Colors.purple
      },
      {'icon': Icons.question_answer, 'title': 'Q & A', 'color': Colors.green},
      {'icon': Icons.search, 'title': 'Look up', 'color': Colors.blue},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(
          icon: feature['icon'] as IconData,
          title: feature['title'] as String,
          color: feature['color'] as Color,
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  "This week's schedule",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildScheduleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    final schedules = [
      {'subject': 'History', 'time': '14:00 - 15:00', 'color': Colors.orange},
      {'subject': 'Geographic', 'time': '15:30 - 16:30', 'color': Colors.green},
      {'subject': 'Chemistry', 'time': '17:00 - 18:00', 'color': Colors.purple},
      {'subject': 'Math', 'time': '18:30 - 19:30', 'color': Colors.blue},
    ];

    return Column(
      children: schedules.map((schedule) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: (schedule['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: schedule['color'] as Color?,
              child: Icon(Icons.book, color: Colors.white, size: 20),
            ),
            title: Text(
              schedule['subject'] as String,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              schedule['time'] as String,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGroupClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Group Classes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildClassCard(
                'Science and Technology',
                'Class Standard 8',
                'Studying',
                Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildClassCard(
                'Math class 8',
                '(1vs1)',
                'Focusing',
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClassCard(
    String title,
    String subtitle,
    String status,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: CustomBottomNavigationTeacherBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/teacherinteractlearning');
              break;
            case 1:
              Navigator.of(context).pushNamed('/teacherclassschedule');
              break;
            case 2:
              Navigator.of(context).pushNamed('/teachercourse');
              break;
            case 3:
              Navigator.of(context).pushNamed('/teacherchat');
              break;
          }
        },
      ),
    );
  }
}
