import 'dart:typed_data';
import 'package:codajoy/models/course_model.dart';
import 'package:flutter/services.dart';

abstract class CoursesService {
  Future<Uint8List?> getPdfFile();
  Future<List<Course>> getCourses();
  Future<bool> addCourse(Course course);
  Future<bool> deleteCourse(String id);
  Future<bool> addComment(String courseId, String text);
}

class MockCoursesService implements CoursesService {
  // Mutable list for CRUD operations
  final List<Course> _mockCourses = [
    Course(
      id: "1",
      title: "Mathématiques 7ème",
      description: "Algèbre, Géométrie et plus.",
      imageAsset: "assets/images/math_course.png",
      pdfUrl: "assets/pdfs/math_7.pdf",
    ),
    Course(
      id: "2",
      title: "Sciences Physiques",
      description: "Physique et Chimie pour débutants.",
      imageAsset: "assets/images/science_course.png",
      pdfUrl: "assets/pdfs/physics.pdf",
    ),
    Course(
      id: "3",
      title: "Informatique",
      description: "Introduction à la programmation Python.",
      imageAsset: "assets/images/cb.png",
      pdfUrl: "assets/pdfs/python.pdf",
    ),
    Course(
      id: "4",
      title: "Histoire & Géo",
      description: "Le monde moderne et ses enjeux.",
      imageAsset: "assets/images/history.png",
      pdfUrl: "assets/pdfs/history.pdf",
    ),
  ];

  @override
  Future<Uint8List?> getPdfFile() async {
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

  @override
  Future<List<Course>> getCourses() async {
    await Future.delayed(Duration(seconds: 1));
    return List.from(_mockCourses);
  }

  @override
  Future<bool> addCourse(Course course) async {
    await Future.delayed(Duration(seconds: 1));
    _mockCourses.add(course);
    return true;
  }

  @override
  Future<bool> deleteCourse(String id) async {
    await Future.delayed(Duration(seconds: 1));
    _mockCourses.removeWhere((c) => c.id == id);
    return true;
  }

  @override
  Future<bool> addComment(String courseId, String text) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _mockCourses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      var old = _mockCourses[index];
      var newComments = List<CourseComment>.from(old.comments);
      newComments.add(CourseComment(
        author: "User",
        text: text,
        date: DateTime.now(),
      ));

      _mockCourses[index] = Course(
        id: old.id,
        title: old.title,
        description: old.description,
        imageAsset: old.imageAsset,
        pdfUrl: old.pdfUrl,
        comments: newComments,
      );
      return true;
    }
    return false;
  }
}
