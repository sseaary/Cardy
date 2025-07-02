import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cardy/game/data.dart';

class AddVocabScreen extends StatelessWidget {
  AddVocabScreen({super.key});

  // ฟังก์ชันเพิ่มข้อมูลเข้า Firestore
  Future<void> addVocabData(BuildContext context) async {
    final CollectionReference vocabCollection = FirebaseFirestore.instance
        .collection('vocab_admin');

    int successCount = 0;
    int failCount = 0;

    for (final vocab in vocabJson) {
      try {
        await vocabCollection.add(vocab);
        successCount++;
        print('✅ เพิ่มคำ "${vocab['words']}" สำเร็จ');
      } catch (e) {
        failCount++;
        print('❌ เพิ่มคำ "${vocab['words']}" ไม่สำเร็จ: $e');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่มสำเร็จ $successCount รายการ, ล้มเหลว $failCount'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มคำศัพท์')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => addVocabData(context),
          child: Text('เพิ่มคำศัพท์ลง Firebase'),
        ),
      ),
    );
  }
}
