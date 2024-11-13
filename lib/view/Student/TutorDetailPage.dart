import 'package:fat_app/Model/UserModel.dart';
import 'package:fat_app/view/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:fat_app/Model/courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isLoading = true;
  String username = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getUserData();
    _loadUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _firestore
          .collection('Users')
          .where("username", isEqualTo: widget.user.userName)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          setState(() {
            userMap = value.docs[0].data();
            isLoading = false;
          });
        } else {
          createUserDocument();
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void createUserDocument() async {
    try {
      Map<String, dynamic> userData = {
        'username': widget.user.userName,
        'email': widget.user.email,
        'uid': _firestore.collection('Users').doc().id,
        'status': 'Offline',
        'position': widget.user.position,
        'created_at': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(userData['uid']).set(userData);

      setState(() {
        userMap = userData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating user: ${e.toString()}')),
      );
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
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

  void startChat() async {
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set your display name first')),
      );
      return;
    }

    if (userMap != null) {
      String roomId =
          chatRoomId(_auth.currentUser!.displayName!, widget.user.userName);

      try {
        DocumentSnapshot chatRoom =
            await _firestore.collection('chatroom').doc(roomId).get();

        if (!chatRoom.exists) {
          await _firestore.collection('chatroom').doc(roomId).set({
            'participants': [
              _auth.currentUser!.displayName,
              widget.user.userName
            ],
            'created_at': FieldValue.serverTimestamp(),
            'last_message': null,
            'last_message_time': null
          });
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatRoom(
              chatRoomId: roomId,
              userMap: {
                'username': widget.user.userName,
                'email': widget.user.email,
                'uid': userMap!['uid'],
                'status': userMap!['status'] ?? 'Offline'
              },
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting chat: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.userName),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'avatar-${widget.user.userName}', // Changed tag
                        child: CircleAvatar(
                          radius: 40,
                          // backgroundImage: const AssetImage('students.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Giáo viên: ${widget.course.teacher}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Môn học: ${widget.course.subject}',
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vị trí: ${widget.user.position}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mô tả: ${widget.course.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Mô tả: ${widget.user.phoneNumber}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Time: ${widget.course.startDate} - ${widget.course.endDate}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: startChat,
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
                              String roomId =
                                  chatRoomId(username, userMap!['username']);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: userMap!,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Inbox',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
                          '4.5/5',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            // Implement review functionality
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
