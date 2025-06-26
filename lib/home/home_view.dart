import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/data.dart';
import 'package:flutter_cardy/game/game_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late List<dynamic> vocab;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // vocab = vocabJson;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      drawer: Drawer(
        backgroundColor: Color(0xFFE5ECF1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Litaphat',
                style: TextStyle(
                  color: Color(0xFF2E82DB),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'sea.panaporn@gmail.com',
                style: TextStyle(color: Color(0xFF2E82DB)),
              ),
              Spacer(),
              ListTile(
                leading: Icon(Icons.edit_note),
                title: Text(
                  "Theme",
                  style: TextStyle(
                    color: Color(0xFF2E82DB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
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
          SizedBox(height: 40),
          Expanded(
            child: ListView.separated(
              itemCount: titleList.length,
              itemBuilder: (context, index) {
                final title = titleList[index];

                return Container(
                  height: 100,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 40),
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
                          .where((json) => json['level'] == title["title_name"])
                          .toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return GameView(vocabs: newVocabsFromLevel);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 40),
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
                        onPressed: () {},
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
        child: Icon(Icons.add, color: Color(0xFF2E82DB), size: 30),
        shape: CircleBorder(),
      ),
    );
  }
}
