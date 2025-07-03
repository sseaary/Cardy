import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      final qs = await FirebaseFirestore.instance
          .collection('vocab_user')
          .where(FieldPath.documentId, whereIn: _savedIds)
          .get();

      _savedVocabs = qs.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
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
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        vocab['words'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(vocab['description'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.bookmark_remove, color: Colors.red),
                        onPressed: () => _unSave(vocab['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
