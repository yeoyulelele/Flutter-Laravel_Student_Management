import 'package:flutter/material.dart';
import 'package:student_management/pages/add_course.dart';
import '../api/api_service.dart';
import '../models/course.dart';

class CourseListPage extends StatefulWidget {
  @override
  _CourseListPageState createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late ApiService _apiService;
  late Future<List<Course>> _courses;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _courses = _apiService.fetchCourses();
  }

  void reloadCourses() {
    setState(() {
      _courses = _apiService.fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 18, 85, 141),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          FutureBuilder<List<Course>>(
            future: _courses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No courses found.'));
              } else {
                final courses = snapshot.data!;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return ListTile(
                      title: Text(course.name),
                      subtitle: Text(course.code),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCourse(
                                    course: course,
                                    onCourseAdded: reloadCourses,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _apiService.deleteCourse(courses[index].id!).then((_) {
                                reloadCourses();
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
                builder: (context) => AddCourse(onCourseAdded: reloadCourses),
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
