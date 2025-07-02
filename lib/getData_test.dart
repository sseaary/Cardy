import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VocabListFutureScreen extends StatelessWidget {
  const VocabListFutureScreen({super.key});

  // ฟังก์ชันดึงข้อมูลจาก Firebase (แบบ Future)
  Future<List<Map<String, dynamic>>> fetchVocabList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('vocab_admin')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('คำศัพท์ทั้งหมด')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchVocabList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          }

          final vocabList = snapshot.data ?? [];

          if (vocabList.isEmpty) {
            return const Center(child: Text('ไม่พบคำศัพท์ในระบบ'));
          }

          return ListView.builder(
            itemCount: vocabList.length,
            itemBuilder: (context, index) {
              final vocab = vocabList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    vocab['image_url'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text('${vocab['words']} ${vocab['pos'] ?? ''}'),
                  subtitle: Text(
                    '${vocab['description'] ?? ''} (ระดับ: ${vocab['level'] ?? '-'})',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
