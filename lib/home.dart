import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              itemCount: 4,
              itemBuilder: (context, index) {
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
                      'Level - A1',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("cards: 20"),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Container(
                height:
                    MediaQuery.of(context).size.height *
                    0.3, // สูง 70% ของหน้าจอ
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 24,
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Create'),
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
