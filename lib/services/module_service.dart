import 'package:allemni/services/child_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModuleService {
  static Future addModuleToSubject({
    required String subjectId,
    required List<Map<String, dynamic>> modules,
  }) async {
    final childId = await ChildService.getSelectedChildId();
    final moduleRef = FirebaseFirestore.instance
        .collection("Children")
        .doc(childId)
        .collection("Subjects")
        .doc(subjectId)
        .collection("Modules");
    for (final module in modules) {
      final docref = moduleRef.doc(module["value"]);
      final docsnap = await docref.get();
      if (!docsnap.exists) {
        await docref.set({
          "name": module["name"],
          "image": module["image"],
          "value": module["value"],
          "score": module["score"] ?? 0,
          "progress": module["progress"] ?? 0.0,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
    }
  }

  static Stream<List<Map<String, dynamic>>> getModules(
    String subjectId,
  ) async* {
    final childId = await ChildService.getSelectedChildId();
    yield* FirebaseFirestore.instance
        .collection("Children")
        .doc(childId)
        .collection("Subjects")
        .doc(subjectId)
        .collection("Modules")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "name": data["name"],
              "image": data["image"],
              "value": data["value"],
              "score": data["score"] ?? 0,
              "progress": data["progress"] ?? 0.0,
            };
          }).toList(),
        );
  }

  static Future<void> updateModuleProgress({
    required String subjectId,
    required String moduleId,
    required double progress,
    required double score,
  }) async {
    final childId = await ChildService.getSelectedChildId();
    final moduleRef = FirebaseFirestore.instance
        .collection("Children")
        .doc(childId)
        .collection("Subjects")
        .doc(subjectId)
        .collection("Modules")
        .doc(moduleId);
    await moduleRef.update({"progress": progress, "score": score});
  }

  static Future<void> uploadModules(
    String subjectId,
    List<Map<String, dynamic>> modules,
  ) async {
    final childId = await ChildService.getSelectedChildId();
    final moduleRef = FirebaseFirestore.instance
        .collection("Children")
        .doc(childId)
        .collection("Subjects")
        .doc(subjectId)
        .collection("Modules");

    for (final module in modules) {
      await moduleRef.doc(module["value"]).set(module);
    }
  }
}
