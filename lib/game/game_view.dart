import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';

class GameView extends StatefulWidget {
  final List vocabs;
  const GameView({super.key, required this.vocabs});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool isOn = true;
  int index = 0;
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
        children: [
          SizedBox(width: double.infinity),
          GestureDetector(
            onTap: () {
              isOn = !isOn;
              setState(() {});
            },
            child: CardVocab(vocab: widget.vocabs[index], isOn: isOn),
          ),
          SizedBox(height: 80),
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if ((index + 1) >= widget.vocabs.length) return;
                index++;
                isOn = true;
                setState(() {});
              },
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
