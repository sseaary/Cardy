import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardVocab extends StatefulWidget {
  final Map<String, dynamic> vocab;
  final bool isOn;
  final String title;
  final bool? showMenu;
  final Function()? onEdit;

  const CardVocab({
    super.key,
    required this.vocab,
    required this.isOn,
    required this.title,
    required this.onEdit,
    this.showMenu = true,
  });

  @override
  State<CardVocab> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CardVocab> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      child: widget.isOn
          ? cardOn(
              size,
              "${widget.vocab['words']} ${widget.vocab['pos'] ?? ""}",
            )
          : cardOff(
              size,
              "${widget.vocab['description']}",
              widget.vocab['image_url'],
            ),
    );
  }

  Container cardOff(Size size, String text, String url) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: (url == false || url.isEmpty)
          ? Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
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
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color(0xFFA3EFF2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 5,
          child: (widget.vocab["default"] == "true" || widget.showMenu == false)
              ? SizedBox.shrink()
              : PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                      case 'delete':
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: widget.onEdit,
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
                                    onPressed: () async {
                                      Get.back(); // ปิด dialog ก่อน

                                      final docId = widget.vocab['id'];
                                      await FirebaseFirestore.instance
                                          .collection('vocab_user')
                                          .doc(docId)
                                          .delete();
                                      Get.back(result: 'deleted');
                                      // Optional: แสดง SnackBar หรือ Toast
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Deleted successfully"),
                                        ),
                                      );

                                      // Optional: กลับหน้าก่อนหรือรีเฟรชหน้าปัจจุบัน
                                      // หรือถ้าคุณต้องให้ GameView โหลดใหม่ ให้ใช้ callback หรือ state management
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
                    ];
                  },
                ),
        ),
      ],
    );
  }
}
