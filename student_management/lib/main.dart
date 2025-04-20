import 'package:flutter/material.dart';
import 'package:student_management/pages/mark_list.dart';
import 'pages/student_list.dart';
import 'pages/course_list.dart';  // Your Course Page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNavBarPage(),  // Set BottomNavBarPage as the home page
    );
  }
}

class BottomNavBarPage extends StatefulWidget {
  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;  // Tracks the currently selected tab
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  // Called when user taps a tab on the bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);  // Change the page
  }

  @override
  void dispose() {
    _pageController.dispose();  // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          StudentListPage(),  // The Student List Page
          CourseListPage(),       // The Course Page
          ExamMarksPage(),        // The Marks Page
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Marks',
          ),
        ],
      ),
    );
  }
}
