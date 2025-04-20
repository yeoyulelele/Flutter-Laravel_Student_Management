import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_management/models/student.dart';
import '../api/api_service.dart';

class AddStudent extends StatefulWidget {
  final VoidCallback? onStudentAdded;
  final Student? student;
  const AddStudent({super.key, this.onStudentAdded, this.student});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? pickedDate;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _emailController.text = widget.student!.email;
      _dobController.text = widget.student!.dob;
    } else {
      _nameController.text = '';
      _emailController.text = '';
      _dobController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student', style: TextStyle(color: Colors.white)),
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select a date of birth';
                  }
                  return null;
                },
                onTap: () async {
                  pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate!);
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.student == null) {
                      final student = Student(
                        name: _nameController.text,
                        email: _emailController.text,
                        dob: _dobController.text,
                      );
                      _apiService
                          .createStudent(student)
                          .then((_) {
                            widget.onStudentAdded!();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Student added successfully',
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
                      final student = Student(
                        id: widget.student!.id,
                        name: _nameController.text,
                        email: _emailController.text,
                        dob: _dobController.text,
                      );
                      _apiService
                          .updateStudent(student)
                          .then((_) {
                            widget.onStudentAdded!();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Student updated successfully',
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
                    widget.student == null
                        ? Text('Add Student')
                        : Text("Update Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
