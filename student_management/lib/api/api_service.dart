import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/exam_mark.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Fetch all students
  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  // Fetch all students
  Future<Student> fetchStudentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/students/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Student.fromJson(data);
    } else {
      throw Exception('Failed to load student');
    }
  }

  // Create a student
  Future<void> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create student');
    }
  }

  // Update student
  Future<void> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/students/${student.id}/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }

  // Delete student
  Future<void> deleteStudent(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/students/$id/destroy'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }

  // Fetch all courses
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<Student> fetchCourseById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/courses/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Student.fromJson(data);
    } else {
      throw Exception('Failed to load course');
    }
  }

  // Create a course
  Future<void> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create course');
    }
  }

  // Update course
  Future<void> updateCourse(Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/${course.id}/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

  // Delete course
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$id/destroy'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete course');
    }
  }

  // Fetch all exam marks
  Future<List<ExamMark>> fetchExamMarks() async {
    final response = await http.get(Uri.parse('$baseUrl/examMarks'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ExamMark.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exam marks');
    }
  }

  // Create exam mark
  Future<void> createExamMark(ExamMark examMark) async {
    final response = await http.post(
      Uri.parse('$baseUrl/examMarks/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(examMark.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create exam mark');
    }
  }

  // Update exam mark
  Future<void> updateExamMark(ExamMark examMark) async {
    final response = await http.put(
      Uri.parse('$baseUrl/examMarks/${examMark.id}/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(examMark.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update exam mark');
    }
  }

  // Delete exam mark
  Future<void> deleteExamMark(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/examMarks/$id/destroy'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete exam mark');
    }
  }

  Future<void> downloadStudentMarksCsv(BuildContext context) async {
    // Request permission to write to storage (for Android)
    PermissionStatus status = await Permission.manageExternalStorage.request();

    print("Permission status是: $status");
    if (status.isGranted) {
      try {
        final url =
            '$baseUrl/studentMarks'; // Replace with your actual API endpoint

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          print("sstatuscode成功");

          // Get the local directory to store the file
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/student_average_report.csv');
          print('是${directory.path}/student_average_report.csv');

          // Write the CSV data to the file
          await file.writeAsBytes(bytes);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student Marks CSV downloaded')),
          );
        } else {
          print("sstatuscode失败");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to download: ${response.statusCode}'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Future<void> downloadCourseMarksCsv(BuildContext context) async {
    // Request permission to write to storage (for Android)
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final url =
            '$baseUrl/courseMarks'; // Replace with your actual API endpoint

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;

          // Get the local directory to store the file
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/course_average_report.csv');

          // Write the CSV data to the file
          await file.writeAsBytes(bytes);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course Marks CSV downloaded')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to download: ${response.statusCode}'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

}
