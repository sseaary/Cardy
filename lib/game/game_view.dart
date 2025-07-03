import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';
import 'package:get/get.dart';

class GameView extends StatefulWidget {
  final String title = Get.arguments["title"];
  final List vocabs = Get.arguments["vocabs"];
  GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool isOn = true;
  int index = 0;
  late List<bool> favoriteStatus;
  late PageController seaController;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    favoriteStatus = List.filled(widget.vocabs.length, false);
    seaController = PageController();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    List savedList = userDoc.data()?['Saved'] ?? [];

    setState(() {
      favoriteStatus = widget.vocabs.map((vocab) {
        // vocab['id'] ควรมี id ของเอกสาร
        return savedList.contains(vocab['id']);
      }).toList();
    });
  }

  Future<void> _toggleFavorite(int idx) async {
    final docId = widget.vocabs[idx]['id'];
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
    seaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("${widget.title}", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D243D),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => NewGame(initialTitle: widget.title));
            },
            icon: Icon(Icons.add, size: 40, color: Color(0xFF2E82DB)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: PageView.builder(
                controller: seaController,
                onPageChanged: (value) {
                  setState(() {
                    isOn = true;
                    index = value;
                  });
                },
                itemCount: widget.vocabs.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isOn = !isOn;
                      });
                    },
                    child: CardVocab(
                      vocab: widget.vocabs[idx],
                      isOn: isOn,
                      title: '${widget.title}',
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 20),
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
                  seaController.animateToPage(
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
                  if ((index + 1) >= widget.vocabs.length) return;
                  setState(() {
                    index++;
                    isOn = true;
                  });
                  seaController.animateToPage(
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
                favoriteStatus[index] ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
