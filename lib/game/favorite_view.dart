import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  List<String> _savedIds = [];
  List<Map<String, dynamic>> _savedVocabs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedVocabs();
  }

  Future<void> _loadSavedVocabs() async {
    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final savedList = List<String>.from(userDoc.data()?['Saved'] ?? []);
    _savedIds = savedList;

    if (_savedIds.isNotEmpty) {
      // แยก id ที่มีอยู่จริงในแต่ละ collection
      // เพราะ query whereIn มีจำกัด 10 ids ต่อ query
      // แต่สมมติในที่นี้ใส่เต็มเลยก่อน (แก้ไขทีหลังถ้ามาก)

      // ดึง vocab_user
      final qsUser = await FirebaseFirestore.instance
          .collection('vocab_user')
          .where(FieldPath.documentId, whereIn: _savedIds)
          .get();

      // ดึง vocab_admin
      final qsAdmin = await FirebaseFirestore.instance
          .collection('vocab_admin')
          .where(FieldPath.documentId, whereIn: _savedIds)
          .get();

      // รวมรายการ
      _savedVocabs = [
        ...qsUser.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['source'] = 'vocab_user';
          return data;
        }),
        ...qsAdmin.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['source'] = 'vocab_admin';
          return data;
        }),
      ];
    } else {
      _savedVocabs = [];
    }

    setState(() => _isLoading = false);
  }

  Future<void> _unSave(String docId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'Saved': FieldValue.arrayRemove([docId]),
    });
    await _loadSavedVocabs();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Removed from saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      appBar: AppBar(
        title: Text('Saved', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF0D243D),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : _savedVocabs.isEmpty
          ? Center(
              child: Text(
                'No saved items',
                style: TextStyle(color: Colors.white),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadSavedVocabs,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _savedVocabs.length,
                itemBuilder: (context, i) {
                  final vocab = _savedVocabs[i];
                  return Slidable(
                    key: ValueKey(vocab['id']),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => _unSave(vocab['id']),
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          icon: Icons.bookmark,
                          label: 'unsaved',
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        bool isOn = true;

                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0,
                                    ),

                                    child: SizedBox(
                                      height: 250,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isOn = !isOn;
                                          });
                                        },
                                        child: CardVocab(
                                          vocab: vocab,
                                          isOn: isOn,
                                          title: 'Saved',
                                          showMenu: false,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        // margin: EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              vocab['words'] ?? '',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
