import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/data.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';
import 'package:get/get.dart';
import 'favorite_view.dart';

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
  bool isFavorite = false;
  late List<bool> favoriteStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favoriteStatus = List.filled(widget.vocabs.length, false);
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
              Get.toNamed("/newGame", arguments: {"title": '${widget.title}'});
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
                  if ((index - 1) <= -1) return;
                  index--;
                  isOn = true;
                  isFavorite = false;
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
                  isFavorite = false;
                  setState(() {});
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
              onPressed: () {
                setState(() {
                  favoriteStatus[index] = !favoriteStatus[index];
                });
              },
              icon: Icon(
                favoriteStatus[index] ? Icons.favorite : Icons.favorite_border,
              ),

              iconSize: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
