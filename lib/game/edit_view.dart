import 'package:flutter/material.dart';

class EditGame extends StatefulWidget {
  final String title;
  const EditGame({super.key, required this.title});

  @override
  State<EditGame> createState() => _EditGameState();
}

class _EditGameState extends State<EditGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('${widget.title}', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D243D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: 330,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E82DB),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'word',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        // borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 100,
                    width: 300,
                    child: Icon(Icons.image),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 60),
                ElevatedButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        "ok",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
