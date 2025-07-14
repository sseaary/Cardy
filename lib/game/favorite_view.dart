import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

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
      final qsUser = await FirebaseFirestore.instance
          .collection('vocab_user')
          .where(FieldPath.documentId, whereIn: _savedIds)
          .get();

      final qsAdmin = await FirebaseFirestore.instance
          .collection('vocab_admin')
          .where(FieldPath.documentId, whereIn: _savedIds)
          .get();

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
    ).showSnackBar(const SnackBar(content: Text('Removed from saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/image/apple.png",
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height,
        ),
        Container(height: double.infinity, color: Color.fromARGB(103, 0, 0, 0)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Saved', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: const Color(0xFF0D243D),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _savedVocabs.isEmpty
              ? const Center(
                  child: Text(
                    'No saved items',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSavedVocabs,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _savedVocabs.length,
                    itemBuilder: (context, i) {
                      final vocab = _savedVocabs[i];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Slidable(
                          key: ValueKey(vocab['id']),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.30,
                            children: [
                              SlidableAction(
                                onPressed: (_) => _unSave(vocab['id']),
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                icon: Icons.bookmark,
                                label: 'unsaved',
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                vocab['words'] ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
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
                                              horizontal: 30.0,
                                            ),
                                            child: SizedBox(
                                              height: 200,
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
                                                  onEdit: () async {
                                                    final newVocab = await Get.to(
                                                      () {
                                                        return NewGame(
                                                          docId:
                                                              _savedVocabs[i]['id'],
                                                          wordData:
                                                              _savedVocabs[i],
                                                        );
                                                      },
                                                    );

                                                    if (newVocab != null) {
                                                      setState(() {
                                                        _savedVocabs[i] =
                                                            newVocab;
                                                      });
                                                    }
                                                  },
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
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
