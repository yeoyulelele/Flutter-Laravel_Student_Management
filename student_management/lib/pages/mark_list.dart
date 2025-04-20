import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/exam_mark.dart';
import '../pages/add_edit_marks.dart';

class ExamMarksPage extends StatefulWidget {
  const ExamMarksPage({super.key});

  @override
  State<ExamMarksPage> createState() => _ExamMarksPageState();
}

class _ExamMarksPageState extends State<ExamMarksPage> {
  late ApiService _apiService;
  late Future<List<ExamMark>> _examMarks;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadExamMarks();
  }

  void _loadExamMarks() {
    setState(() {
      _examMarks = _apiService.fetchExamMarks();
    });
  }

  void _deleteExamMark(int id) async {
    try {
      await _apiService.deleteExamMark(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Exam mark deleted')));
      _loadExamMarks();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  void _navigateToAddEdit({ExamMark? mark}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddEditExamMark(examMark: mark, onSaved: _loadExamMarks),
      ),
    );
    if (result == true) {
      _loadExamMarks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Marks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 18, 85, 141),
      ),
      body: FutureBuilder<List<ExamMark>>(
        future: _examMarks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No exam marks found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final mark = snapshot.data![index];
                return ListTile(
                  title: Text(
                    'Student ID: ${mark.studentId} - Course ID: ${mark.courseId}',
                  ),
                  subtitle: Text('Marks: ${mark.marks}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToAddEdit(mark: mark),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteExamMark(mark.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 70, // customize the size
        height: 70,
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditExamMark(onSaved: _loadExamMarks),
              ),
            );
            if (result == true) {
              _loadExamMarks();
            }
          },
          backgroundColor: Colors.blue, // make icon bigger too
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
      // Add buttons at the bottom of the screen
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _apiService.downloadStudentMarksCsv(context),
                icon: const Icon(Icons.download),
                label: const Text("Download Student Marks Report"),
              ),
            ),

            const SizedBox(width: 20),
            Expanded(
              child: TextButton.icon(
                onPressed: () => _apiService.downloadCourseMarksCsv(context),
                icon: const Icon(Icons.download),
                label: const Text("Download Course Marks Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
