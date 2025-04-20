import 'package:flutter/material.dart';
import 'package:student_management/models/course.dart';
import 'package:student_management/models/student.dart';
import '../api/api_service.dart';
import '../models/exam_mark.dart';

class AddEditExamMark extends StatefulWidget {
  final ExamMark? examMark;
  final VoidCallback? onSaved;

  const AddEditExamMark({super.key, this.examMark, this.onSaved});

  @override
  State<AddEditExamMark> createState() => _AddEditExamMarkState();
}

class _AddEditExamMarkState extends State<AddEditExamMark> {
  final _formKey = GlobalKey<FormState>();
  List<Student> _students = [];
  List<Course> _courses = [];
  int? _selectedStudentId;
  int? _selectedCourseId;

  final _marksController = TextEditingController();

  late ApiService _apiService;

  @override
  @override
  void initState() {
    super.initState();
    _apiService = ApiService();

    _loadData();

    if (widget.examMark != null) {
      _selectedStudentId = widget.examMark!.studentId;
      _selectedCourseId = widget.examMark!.courseId;
      _marksController.text = widget.examMark!.marks.toString();
    }
  }

  void _loadData() async {
    try {
      final students = await _apiService.fetchStudents();
      final courses = await _apiService.fetchCourses();
      setState(() {
        _students = students;
        _courses = courses;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  @override
  void dispose() {
    _marksController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final mark = ExamMark(
        id: widget.examMark?.id,
        studentId: _selectedStudentId!,
        courseId: _selectedCourseId!,
        marks: int.parse(_marksController.text),
      );

      try {
        if (widget.examMark == null) {
          await _apiService.createExamMark(mark);
        } else {
          await _apiService.updateExamMark(mark);
        }

        widget.onSaved?.call();
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.examMark != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Exam Mark' : 'Add Exam Mark',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 18, 85, 141),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedStudentId,
                items:
                    _students.map((student) {
                      return DropdownMenuItem<int>(
                        value: student.id,
                        child: Text(student.name),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudentId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Student'),
                validator:
                    (value) => value == null ? 'Please select a student' : null,
              ),

              DropdownButtonFormField<int>(
                value: _selectedCourseId,
                items:
                    _courses.map((course) {
                      return DropdownMenuItem<int>(
                        value: course.id,
                        child: Text(course.code),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourseId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Course'),
                validator:
                    (value) => value == null ? 'Please select a course' : null,
              ),

              TextFormField(
                controller: _marksController,
                decoration: const InputDecoration(labelText: 'Marks'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
