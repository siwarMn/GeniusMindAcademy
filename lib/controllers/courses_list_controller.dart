import 'package:codajoy/models/course_model.dart';
import 'package:codajoy/services/courses_service.dart';
import 'package:get/get.dart';

class CoursesListController extends GetxController {
  final CoursesService _service = MockCoursesService();

  var isLoading = false.obs;
  var courses = <Course>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      isLoading(true);
      var fetched = await _service.getCourses();
      courses.assignAll(fetched);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      isLoading(true);
      await _service.addCourse(course);
      await fetchCourses();
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      isLoading(true);
      await _service.deleteCourse(id);
      await fetchCourses();
    } finally {
      isLoading(false);
    }
  }

  Future<void> addComment(String id, String text) async {
    try {
      isLoading(true);
      await _service.addComment(id, text);
      await fetchCourses();
    } finally {
      isLoading(false);
    }
  }
}
