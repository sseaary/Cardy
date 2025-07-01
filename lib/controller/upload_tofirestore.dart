import 'package:cloud_firestore/cloud_firestore.dart';

class UploadTofirestore {
  Future<void> upload(
    Map<String, dynamic> data,
    String? uid,
    String title,
  ) async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
    final userData = snapshot.data() as Map<String, dynamic>?;
    final Map<String, dynamic> addCard =
        userData?["add_card"] as Map<String, dynamic>? ?? {};
    final existingData = addCard[title];

    print("Current add_card: $addCard");
    print("Current data for '$title': $existingData");
    if (existingData == null) {
      // ถ้าไม่มี title นี้มาก่อน
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "add_card": {
          title: [data],
        },
      }, SetOptions(merge: true));
    } else {
      // ถ้ามี title นี้อยู่แล้ว
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "add_card.$title": FieldValue.arrayUnion([data]),
      });
    }
  }
}
