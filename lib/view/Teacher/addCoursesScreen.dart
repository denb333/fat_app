// lib/screens/add_courses_screen.dart
import 'package:fat_app/service/coursesService.dart';
import 'package:flutter/material.dart';
import 'package:fat_app/Model/courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCoursesScreen extends StatefulWidget {
  const AddCoursesScreen({Key? key}) : super(key: key);

  @override
  _AddCoursesScreenState createState() => _AddCoursesScreenState();
}

class _AddCoursesScreenState extends State<AddCoursesScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CourseService _courseService = CourseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    _teacherController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _priceController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = '${pickedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<int> _getId() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Courses')
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return 1;
    }

    int currentID = querySnapshot.docs.first.get('id') as int;
    return currentID + 1;
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Create a Course object
        int nextid = await _getId();
        Course course = Course(
          id: nextid.toString(),
          teacher: _teacherController.text,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
          price: double.parse(_priceController.text),
          subject: _subjectController.text,
          description: _descriptionController.text,
          creatorId: user.uid,
          createdAt: FieldValue.serverTimestamp() as Timestamp,
          chapterId: [],
        );

        try {
          // Save course data using CourseService
          await _courseService.saveCourse(course);

          // Show success message and navigate back to previous screen
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Course added successfully!')));
          Navigator.of(context).pop();
        } catch (e) {
          // Handle any errors
          print('Failed to add course: $e');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to add course')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Courses'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildTextField(
                        controller: _subjectController,
                        label: 'Subject',
                        hint: 'Enter subject',
                      ),
                      _buildTextField(
                        controller: _startDateController,
                        label: 'Start Date',
                        hint: 'Select start date',
                        readOnly: true,
                        onTap: () => _selectDate(_startDateController),
                      ),
                      _buildTextField(
                        controller: _endDateController,
                        label: 'End Date',
                        hint: 'Select end date',
                        readOnly: true,
                        onTap: () => _selectDate(_endDateController),
                      ),
                      _buildTextField(
                        controller: _teacherController,
                        label: 'Teacher',
                        hint: 'Enter teacher\'s name',
                      ),
                      _buildTextField(
                        controller: _priceController,
                        label: 'Price',
                        hint: 'Enter price in USD',
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Enter a brief description of the course',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _saveCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.lightBlue.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label == 'Price' && double.tryParse(value) == null) {
            return 'Please enter a valid number for price';
          }
          return null;
        },
      ),
    );
  }
}
