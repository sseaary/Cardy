import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/widget/card_vocab.dart';
import 'package:get/get.dart';

class FavoriteView extends StatelessWidget {
  // final List vocabs = Get.arguments["vocabs"];
  // final String title = Get.arguments["title"];

  FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D243D),
      appBar: AppBar(
        title: Text('saved', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0D243D),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // body: vocabs.isEmpty
      //     ? Center(
      //         child: Text(
      //           'No word',
      //           style: TextStyle(color: Colors.white, fontSize: 18),
      //         ),
      //       )
      // : ListView.builder(
      //     itemCount: vocabs.length,
      //     itemBuilder: (context, index) {
      //       return Padding(
      //         padding: const EdgeInsets.symmetric(
      //           vertical: 8.0,
      //           horizontal: 16,
      //         ),
      //         child: CardVocab(
      //           vocab: vocabs[index],
      //           isOn: true,
      //           title: title,
      //         ),
      //       );
      //     },
      //   ),
    );
  }
}
