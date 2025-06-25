import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      appBar: AppBar(
        title: Text("level", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D243D),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add, size: 40, color: Color(0xFF2E82DB)),
          ),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isTap = !isTap;
                });
              },

              child: isTap
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFF8FD9FF),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                      width: 300,
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [Icon(Icons.edit), Text('Edit')],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                              icon: Icon(Icons.more_horiz),
                            ),
                          ),
                          Text(
                            "word",
                            style: TextStyle(fontSize: 30),
                            textAlign:
                                TextAlign.end, //หาทางแก้ตำแหน่งให้อยู่ตรงกลาง
                          ),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                      width: 300,
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(Icons.arrow_back_ios),
                          // ),
                          Text("แปล", style: TextStyle(fontSize: 30)),
                        ],
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
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF2E82DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
              ),

              child: Text(
                "Next",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
