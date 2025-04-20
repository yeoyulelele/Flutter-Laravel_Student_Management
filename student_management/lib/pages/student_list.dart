import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/student.dart';
import '../pages/add_student.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late ApiService _apiService;
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _students = _apiService.fetchStudents();
  }

  void reloadStudents() {
    setState(() {
      _students = _apiService.fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 18, 85, 141),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          FutureBuilder<List<Student>>(
            future: _students,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No students found.'));
              } else {
                final students = snapshot.data!;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return ListTile(
                      title: Text(student.name),
                      subtitle: Text(student.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AddStudent(
                                        student: student,
                                        onStudentAdded: reloadStudents,
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _apiService
                                  .deleteStudent(students[index].id!)
                                  .then((_) {
                                    reloadStudents();
                                  });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70, // customize the size
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AddStudent(onStudentAdded: reloadStudents),
              ),
            );
          },
          backgroundColor: Colors.blue, // make icon bigger too
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
    );
  }
}
