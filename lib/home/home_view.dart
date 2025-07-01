import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/data.dart';
import 'package:flutter_cardy/game/favorite_view.dart';
import 'package:flutter_cardy/game/game_view.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/util/storage.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List newTitle = [];
  List userTitle = [
    {"title_name": "User card", "total": 20},
    {"title_name": "User card", "total": 20},
    {"title_name": "User card", "total": 20},
    {"title_name": "User card", "total": 20},
  ];
  String? userName;
  String? userEmail;
  late TextEditingController newTitleController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newTitleController = TextEditingController();
    newTitle = [...titleList] + [...userTitle];

    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? 'Guest';
      userEmail = user?.email ?? '';
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      drawer: Drawer(
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
      ),
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
              // onChanged: (value) {
              //   setState(() {});
              // },
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
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ...titleList.map(
                  (title) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'Level - ${title["title_name"]}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text("cards: ${title["total"]}"),
                        onTap: () {
                          List newVocabsFromLevel = vocabJson
                              .where(
                                (json) => json['level'] == title["title_name"],
                              )
                              .toList();
                          if (newVocabsFromLevel.isEmpty) {
                            Get.toNamed(
                              "/newGame",
                              arguments: {"title": '${title["title_name"]}'},
                            );
                          } else {
                            Get.toNamed(
                              "/gameView",
                              arguments: {
                                "vocabs": newVocabsFromLevel,
                                "title": '${title["title_name"]}',
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                ...userTitle.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        bool confirm = false;
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Confirm Delete"),
                            content: Text(
                              "Are you sure you want to delete this card?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  confirm = true;
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        return confirm;
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        setState(() {
                          userTitle.removeAt(index);
                        });
                      },
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: Text(
                            '${title["title_name"]}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("cards: ${title["total"]}"),
                          onTap: () {
                            List newVocabsFromLevel = vocabJson
                                .where(
                                  (json) =>
                                      json['level'] == title["title_name"],
                                )
                                .toList();
                            if (newVocabsFromLevel.isEmpty) {
                              Get.toNamed(
                                "/newGame",
                                arguments: {"title": '${title["title_name"]}'},
                              );
                            } else {
                              Get.toNamed(
                                "/gameView",
                                arguments: {
                                  "vocabs": newVocabsFromLevel,
                                  "title": '${title["title_name"]}',
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // เปิดให้สูงเกินค่า default
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Container(
                height:
                    MediaQuery.of(context).size.height *
                    0.4, // % ความสูงของหน้าจอ
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 24,
                ),
                child: Column(
                  children: [
                    Title(
                      color: Colors.black,
                      child: Text(
                        "My Card",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),

                      child: TextField(
                        controller: newTitleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Container(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          userTitle.add({
                            "title_name": newTitleController.text,
                            "total": 0,
                          });
                          Get.back();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E82DB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12),
                          ),
                        ),

                        child: Text(
                          "create",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Color(0xFF2E82DB), size: 30),
      ),
    );
  }
}
