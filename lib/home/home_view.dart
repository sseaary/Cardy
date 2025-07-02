import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cardy/util/storage.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List title = [];
  List _title = [];
  List<Map<String, dynamic>> items = [];

  String? userName;
  String? userEmail;

  // ฟังก์ชันดึงข้อมูลจาก Firebase (แบบ Future)
  Future<List<Map<String, dynamic>>> fetchVocabList(
    String collectionPath,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getVocabAdmin() {
    return fetchVocabList('vocab_admin');
  }

  Future<List<Map<String, dynamic>>> getVocabUser() {
    return fetchVocabList('vocab_user');
  }

  Future<void> setItems() async {
    items.clear();
    items.addAll(await getVocabAdmin());
    items.addAll(await getVocabUser());

    Map newMap = groupBy(items, (Map obj) => obj['level']);
    title = List.generate(newMap.keys.length, (int index) {
      return {
        'title_name': newMap.keys.toList()[index],
        'total': (newMap['${newMap.keys.toList()[index]}'] as List).length,
      };
    });
    _title = List.from(title);
    setState(() {});
  }

  void setUserData() {
    final user = FirebaseAuth.instance.currentUser;
    userName = user?.displayName ?? 'Guest';
    userEmail = user?.email ?? '';
    setState(() {});
  }

  @override
  void initState() {
    setItems();
    setUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      drawer: _profile(),
      appBar: AppBar(
        title: Text("CARDY", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D243D),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed("/favoriteView");
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'search',
                suffixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  title = _title;
                } else {
                  title = title.where((e) {
                    return (e['title_name'] as String).toUpperCase().contains(
                      value.toUpperCase(),
                    );
                  }).toList();
                }
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await setItems(),
              child: ListView.builder(
                itemCount: title.length,
                itemBuilder: (context, index) {
                  final newItem = title[index];
                  return _titleCard(newItem);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Get.toNamed("/newGame", arguments: {"title": ''});
        },
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Color(0xFF2E82DB), size: 30),
      ),
    );
  }

  Padding _titleCard(title) {
    List levelDefault = ['A1', 'A2', 'B1', 'B2'];
    bool isShow = levelDefault.contains('${title["title_name"]}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: ListTile(
          title: Text(
            isShow
                ? 'Level - ${title["title_name"]}'
                : ' ${title["title_name"]}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),

          subtitle: Text("cards: ${title["total"]}"),
          onTap: () {
            List newVocabsFromLevel = items
                .where((json) => json['level'] == title["title_name"])
                .toList();
            Get.toNamed(
              "/gameView",
              arguments: {
                "vocabs": newVocabsFromLevel,
                "title": '${title["title_name"]}',
              },
            );
          },
        ),
      ),
    );
  }

  Drawer _profile() {
    return Drawer(
      width: 250,
      backgroundColor: Color(0xFFE5ECF1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              userName ?? '',
              style: TextStyle(
                color: Color(0xFF2E82DB),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(userEmail ?? '', style: TextStyle(color: Color(0xFF2E82DB))),
            Spacer(),
            ListTile(
              onTap: () {
                Storage().removeUserId();
                Get.offAllNamed('/');
              },
              leading: Icon(Icons.login_outlined),
              title: Text(
                "Log out",
                style: TextStyle(
                  color: Color(0xFF2E82DB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
