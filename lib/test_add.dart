import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/controller/upload_img.dart';
import 'package:flutter_cardy/util/storage.dart';

class WordFormPage extends StatefulWidget {
  const WordFormPage({super.key});

  @override
  State<WordFormPage> createState() => _WordFormPageState();
}

class _WordFormPageState extends State<WordFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String imageUrl = "";

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // เก็บข้อมูล
      final Map<String, dynamic> formData = {
        "words": _wordController.text,
        "level": _levelController.text,
        "description": _descriptionController.text,
        "image_url": imageUrl,
        "created_by": Storage().getUserId(),
      };
      await FirebaseFirestore.instance.collection('vocab_user').add(formData);
      // แสดง dialog หรือส่งข้อมูล
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("Form submitted successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
          title: Text("Add Card", style: TextStyle(color: Colors.white)),
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
                            imageUrl = url;
                            setState(() {});
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
                            child: Image.network(
                              imageUrl,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  size: 32,
                                  color: Colors.grey,
                                );
                              },
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
                    ),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Submit"),
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
