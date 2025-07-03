import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/controller/upload_img.dart';
import 'package:flutter_cardy/util/storage.dart';
import 'package:get/get.dart';

class NewGame extends StatefulWidget {
  final Map<String, dynamic>? wordData; // รับข้อมูลที่ใช้แก้ไข
  final String? docId; // ใช้สำหรับอ้างอิงเอกสารเดิมตอนแก้ไข
  final String? initialTitle; // เพิ่มตรงนี้

  const NewGame({super.key, this.wordData, this.docId, this.initialTitle});

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String imageUrl = "";
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    if (widget.wordData != null && widget.docId != null) {
      isEditMode = true;
      _wordController.text = widget.wordData!['words'] ?? '';
      _levelController.text = widget.wordData!['level'] ?? '';
      _descriptionController.text = widget.wordData!['description'] ?? '';
      imageUrl = widget.wordData!['image_url'] ?? '';
    } else if (widget.initialTitle != null && widget.initialTitle!.isNotEmpty) {
      _levelController.text = widget.initialTitle!;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        "words": _wordController.text,
        "level": _levelController.text,
        "description": _descriptionController.text,
        "image_url": imageUrl,
        "created_by": Storage().getUserId(),
      };

      if (isEditMode) {
        // แก้ไขข้อมูล
        await FirebaseFirestore.instance
            .collection('vocab_user')
            .doc(widget.docId)
            .update(formData);
      } else {
        // เพิ่มข้อมูลใหม่
        await FirebaseFirestore.instance.collection('vocab_user').add(formData);
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text(
            isEditMode ? "Updated successfully!" : "Added successfully!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _cancelForm() {
    _formKey.currentState!.reset();
    _wordController.clear();
    _levelController.clear();
    _descriptionController.clear();
    imageUrl = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF0D243D),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            isEditMode ? "Edit Card" : "Add Card",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF0D243D),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _levelController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a Title'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _wordController,
                        decoration: InputDecoration(
                          labelText: 'Words',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a word'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 4,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter description'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          final imgPath = await UploadImg().pickImage();
                          if (imgPath.isNotEmpty) {
                            final url = await UploadImg().uploadImage(imgPath);
                            setState(() {
                              imageUrl = url;
                            });
                          }
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: imageUrl.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      imageUrl,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _cancelForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    child: Text(isEditMode ? "Update" : "Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
