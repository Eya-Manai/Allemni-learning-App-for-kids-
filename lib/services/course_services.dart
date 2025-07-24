import 'package:cloud_firestore/cloud_firestore.dart';

class CourseServices {
  static Future<void> uploadModulestoFirebase({
    required String subjectId,
    required String moduleId,
    required String courseId,
    required Map<String, dynamic> coursesData,
  }) async {
    try {
      final courseRf = FirebaseFirestore.instance
          .collection("Subjects")
          .doc(subjectId)
          .collection("Modules")
          .doc(moduleId)
          .collection("Courses");
      for (final course in coursesData['courses']) {
        //garantee to have a unique id for each course
        final courseId =
            course['id'] ??
            FirebaseFirestore.instance.collection('tmp').doc().id;
        await courseRf.doc(courseId).set(course);
        //ignore: avoid_print
        print("✅ Uploaded course: ${course['name']}");
      }
    } catch (e) {
      throw Exception("Error uploading courses to Firebase: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCourses({
    required String childId,
    required String subjectId,
    required String moduleId,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Children")
          .doc(childId)
          .collection("Subjects")
          .doc(subjectId)
          .collection("Modules")
          .doc(moduleId)
          .collection("Courses")
          .orderBy("order")
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Error fetching courses from Firebase: $e");
    }
  }

  static Future<void> uploadDefaultCourses({
    required String childId,
    required String subjectId,
    required String moduleId,
    required List<Map<String, dynamic>> defaultCourses,
  }) async {
    try {
      final courseRef = FirebaseFirestore.instance
          .collection("Children")
          .doc(childId)
          .collection("Subjects")
          .doc(subjectId)
          .collection("Modules")
          .doc(moduleId)
          .collection("Courses");
      for (final course in defaultCourses) {
        //ignore:avoid_print
        print("➡️ ${course['id']} | ${course['name']} | ${course['image']}");
        final id = course['id'] as String;
        courseRef.doc(id).set(course);
      }
    } catch (e) {
      throw Exception("Error uploading default courses: $e");
    }
  }
}
