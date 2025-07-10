import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildService {
  static Future<void> saveSelectedChildId(String id) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString("selectedChildId", id);
  }

  static Future<String?> getSelectedChildId() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString("selectedChildId");
  }

  static Future<Map<String, dynamic>?> getChildData() async {
    final childId = await getSelectedChildId();
    if (childId == null) {
      throw Exception("No child Id found");
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection("Children")
          .doc(childId)
          .get();
      final data = doc.data();

      if (data == null) {
        throw Exception("No data found for the child : $childId");
      }
      return data;
    } catch (e) {
      throw Exception("failed to fetch child data $e");
    }
  }

  static Future<void> updateCharacter(Map<String, dynamic> character) async {
    final childId = await getSelectedChildId();
    if (childId == null) {
      throw Exception("No child found");
    }
    try {
      await FirebaseFirestore.instance
          .collection("Children")
          .doc(childId)
          .update({
            "character": {
              "name": character["name"],
              "avatar": character["avatar"],
            },
          });
    } catch (e) {
      throw Exception("Failed to Update character");
    }
  }

  static Future<void> updateClass(Map<String, dynamic> classValue) async {
    final childId = await getSelectedChildId();
    if (childId == null) {
      throw Exception("No child found for this class");
    }
    try {
      await FirebaseFirestore.instance
          .collection("Children")
          .doc(childId)
          .update({"ConfirmClassValue": classValue["value"]});
    } catch (e) {
      throw Exception("Failed to Update class in the Firestore $e");
    }
  }
}
