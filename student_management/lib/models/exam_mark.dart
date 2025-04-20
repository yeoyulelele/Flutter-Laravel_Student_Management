class ExamMark {
  final int? id;
  final int studentId;
  final int courseId;
  final int marks;

  ExamMark({this.id,required this.studentId, required this.courseId, required this.marks});

  factory ExamMark.fromJson(Map<String, dynamic> json) {
    return ExamMark(
      id: json['id'],
      studentId: json['student_id'],
      courseId: json['course_id'],
      marks: json['marks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'marks': marks,
    };
  }
}
