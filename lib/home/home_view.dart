import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/util/storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  void _deleteCustomLevel(String levelName) async {
    try {
      // ลบจาก Firestore (เฉพาะ collection vocab_user)
      final vocabUserCollection = FirebaseFirestore.instance.collection(
        'vocab_user',
      );
      final snapshot = await vocabUserCollection
          .where('level', isEqualTo: levelName)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // ลบจากตัวแปรภายในแอป
      items.removeWhere((item) => item['level'] == levelName);
      title.removeWhere((t) => t['title_name'] == levelName);
      _title.removeWhere((t) => t['title_name'] == levelName);

      setState(() {});

      Get.snackbar(
        'Success',
        'Deleted level "$levelName" from Firebase',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  void confirmDeleteDialog(String levelName) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Are you sure"),

          actions: [
            CupertinoDialogAction(
              child: Text("cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCustomLevel(levelName);
              },
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันดึงข้อมูลจาก Firebase (แบบ Future)
  Future<List<Map<String, dynamic>>> fetchVocabList(
    String collectionPath,
  ) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (collectionPath == 'vocab_user') {
      snapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where('created_by', isEqualTo: Storage().getUserId())
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .get();
    }

    // return snapshot.docs.map((doc) => doc.data()).toList();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
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
        title: Text(
          "C A R D Y",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
        onPressed: () async {
          await Get.toNamed("/newGame", arguments: {"title": ''});
          setItems();
        },
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Color(0xFF2E82DB), size: 30),
      ),
    );
  }

  Widget _titleCard(title) {
    List levelDefault = ['A1', 'A2', 'B1', 'B2'];
    bool isShow = levelDefault.contains('${title["title_name"]}');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Slidable(
        key: ValueKey(title["title_name"]),
        enabled: !isShow, // ไม่ให้สไลด์ได้หากเป็น level default
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.30,

          children: [
            SlidableAction(
              onPressed: (_) => confirmDeleteDialog(title["title_name"]),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),

        child: Container(
          height: 100,
          padding: EdgeInsets.all(16),
          color: Colors.white,

          child: ListTile(
            title: Text(
              isShow
                  ? 'Level - ${title["title_name"]}'
                  : ' ${title["title_name"]}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text("cards: ${title["total"]}"),
            onTap: () async {
              List newVocabsFromLevel = items
                  .where((json) => json['level'] == title["title_name"])
                  .toList();

              await Get.toNamed(
                "/gameView",
                arguments: {
                  "vocabs": newVocabsFromLevel,
                  "title": '${title["title_name"]}',
                },
              );
              setItems();
            },
          ),
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
