import 'package:flutter/material.dart';
import 'package:student_management/models/course.dart';
import '../api/api_service.dart';

class AddCourse extends StatefulWidget {
  final VoidCallback? onCourseAdded;
  final Course? course;
  const AddCourse({super.key, this.onCourseAdded, this.course});

  @override
  State<AddCourse> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    if (widget.course != null) {
      _nameController.text = widget.course!.name;
      _codeController.text = widget.course!.code;
    } else {
      _nameController.text = '';
      _codeController.text = '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course', style: TextStyle(color: Colors.white)),
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
          key: _formKey, // ← attach the form key here
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Code (Not more than 5 characters)',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an code';
                  } else if (value.length > 5) {
                    return 'Code should not exceed 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.course == null) {
                      final course = Course(
                        name: _nameController.text,
                        code: _codeController.text.toUpperCase(),
                      );

                      _apiService
                          .createCourse(course)
                          .then((_) {
                            widget.onCourseAdded!();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Courses added successfully',
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Color.fromARGB(
                                  255,
                                  69,
                                  240,
                                  6,
                                ),
                              ),
                            );
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: $error',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                    } else {
                      final course = Course(
                        id: widget.course!.id,
                        name: _nameController.text,
                        code: _codeController.text.toUpperCase(),
                      );
                      _apiService
                          .updateCourse(course)
                          .then((_) {
                            widget.onCourseAdded!();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Courses updated successfully',
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Color.fromARGB(
                                  255,
                                  69,
                                  240,
                                  6,
                                ),
                              ),
                            );
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: $error',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                    }
                  }
                },
                child:
                    widget.course == null
                        ? Text('Add Course')
                        : Text('Update Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
