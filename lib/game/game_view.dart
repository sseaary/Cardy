import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/data.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';

class GameView extends StatefulWidget {
  final String title;
  final List vocabs;
  const GameView({super.key, required this.vocabs, required this.title});

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
        title: Text("${widget.title}", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D243D),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewGame(title: '${widget.title}'),
                ),
              );
            },
            icon: Icon(Icons.add, size: 40, color: Color(0xFF2E82DB)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity),
          ),
          GestureDetector(
            onTap: () {
              isOn = !isOn;
              setState(() {});
            },
            child: CardVocab(
              vocab: widget.vocabs[index],
              isOn: isOn,
              title: '${widget.title}',
            ),
          ),
          SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  if ((index - 1) <= 0) return;
                  index--;
                  isOn = true;
                  setState(() {});
                },
                icon: Icon(Icons.arrow_back_ios_rounded),
                iconSize: 40,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  if ((index + 1) >= widget.vocabs.length) return;
                  index++;
                  isOn = true;
                  setState(() {});
                },
                icon: Icon(Icons.arrow_forward_ios_rounded),
                iconSize: 40,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
