import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/game/data.dart';
import 'package:flutter_cardy/game/edit_view.dart';
import 'package:get/get.dart';

class CardVocab extends StatefulWidget {
  final Map vocab;
  final bool isOn;
  final String title;

  const CardVocab({
    super.key,
    required this.vocab,
    required this.isOn,
    required this.title,
  });

  @override
  State<CardVocab> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CardVocab> {
  void check() {
    vocabJson.map((e) => e.contain(widget.vocab["word"]));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      child: widget.isOn
          ? cardOn(size, "${widget.vocab['words']} ${widget.vocab['pos']}")
          : cardOff(
              size,
              "${widget.vocab['description']}",
              widget.vocab['image_url'],
            ),
    );
  }

  Container cardOff(Size size, String text, String url) {
    return Container(
      height: size.width - 78,
      width: size.width - 78,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }

  Stack cardOn(Size size, String text) {
    return Stack(
      children: [
        Container(
          height: size.width - 78,
          width: size.width - 78,
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color.fromRGBO(143, 217, 255, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 5,
          child: widget.vocab["default"] == "true"
              ? Text("")
              : PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                      case 'delete':
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        Get.toNamed(
                          "/editGame",
                          arguments: {"title": '${widget.title}'},
                        );
                      },
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Are you sure?'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () => Get.back(),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: Text('Delete'),
                                  onPressed: () {
                                    Get.back();
                                    // ทำการลบข้อมูลที่นี่
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 10),
                          Text("Delete"),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
