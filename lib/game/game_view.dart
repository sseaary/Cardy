import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';
import 'package:get/get.dart';

class GameView extends StatefulWidget {
  GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final String title = Get.arguments["title"];
  final List vocabs = Get.arguments["vocabs"];
  bool isOn = true;
  int index = 0;
  late List<bool> favoriteStatus;
  late PageController pageController;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List fakeList = Get.arguments["vocabs"];

  @override
  void initState() {
    super.initState();
    favoriteStatus = List.filled(fakeList.length, false);
    pageController = PageController();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    List savedList = userDoc.data()?['Saved'] ?? [];

    setState(() {
      favoriteStatus = fakeList.map((vocab) {
        // vocab['id'] ควรมี id ของเอกสาร
        return savedList.contains(vocab['id']);
      }).toList();
    });
  }

  Future<void> _toggleFavorite(int idx) async {
    final docId = fakeList[idx]['id'];
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    if (favoriteStatus[idx]) {
      // ลบออก
      await userRef.update({
        'Saved': FieldValue.arrayRemove([docId]),
      });
    } else {
      // เพิ่มเข้าไป
      await userRef.update({
        'Saved': FieldValue.arrayUnion([docId]),
      });
    }

    setState(() {
      favoriteStatus[idx] = !favoriteStatus[idx];
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/image/abc.png",
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height,
        ),
        Container(height: double.infinity, color: Color.fromARGB(103, 0, 0, 0)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back(result: true);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(title, style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF0D243D),
            actions: [
              IconButton(
                onPressed: () async {
                  final newVocab = await Get.to(
                    () => NewGame(initialTitle: title),
                  );

                  if (newVocab != null) {
                    setState(() {
                      fakeList.add(newVocab);
                      favoriteStatus.add(false);
                    });
                  }
                },
                icon: Icon(Icons.add, size: 40, color: Color(0xFF2E82DB)),
              ),
            ],
          ),

          body: Column(
            children: [
              SizedBox(height: 250),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        isOn = true;
                        index = value;
                      });
                    },
                    itemCount: fakeList.length,
                    itemBuilder: (context, idx) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isOn = !isOn;
                          });
                        },

                        child: CardVocab(
                          vocab: fakeList[idx],
                          isOn: isOn,
                          title: title,
                          onEdit: () async {
                            final newVocab = await Get.to(() {
                              return NewGame(
                                docId: fakeList[idx]['id'],
                                wordData: fakeList[idx],
                              );
                            });

                            if (newVocab != null) {
                              setState(() {
                                fakeList[idx] = newVocab;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if ((index - 1) <= -1) return;
                      setState(() {
                        index--;
                        isOn = true;
                      });
                      pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      if ((index + 1) >= fakeList.length) return;
                      setState(() {
                        index++;
                        isOn = true;
                      });
                      pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ],
              ),
              Spacer(),
              SafeArea(
                minimum: const EdgeInsets.only(bottom: 20),
                child: IconButton(
                  onPressed: () => _toggleFavorite(index),
                  icon: Icon(
                    favoriteStatus[index]
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.pink,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
