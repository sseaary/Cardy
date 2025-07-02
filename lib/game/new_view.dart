import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cardy/controller/upload_img.dart';
import 'package:flutter_cardy/util/storage.dart';
import 'package:get/get.dart';

class NewGame extends StatefulWidget {
  final String title = Get.arguments["title"];
  NewGame({super.key});

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
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
                    onPressed: () {
                      _cancelForm;
                      Get.back(result: "cancel");
                    },
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

//   final TextEditingController wordController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   File? _imageFile;

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     wordController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0D243D),
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         title: Text("${widget.title}", style: TextStyle(color: Colors.white)),
//         backgroundColor: Color(0xFF0D243D),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                 ),
//                 padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                 width: 330,
//                 height: 400,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "New",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2E82DB),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextField(
//                       controller: wordController,
//                       decoration: InputDecoration(
//                         labelText: 'New word',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: () async {
//                         final imgPath = await UploadImg().pickImage();
//                         setState(() {
//                           _imageFile = File(imgPath);
//                         });
//                       },
//                       child: Container(
//                         height: 100,
//                         width: 300,
//                         decoration: BoxDecoration(
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: _imageFile != null
//                             ? Stack(
//                                 children: [
//                                   Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: ClipRRect(
//                                         child: Image.file(
//                                           _imageFile!,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 4,
//                                     right: 4,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           _imageFile = null;
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.black.withOpacity(0.3),
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: EdgeInsets.all(4),
//                                         child: Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Center(
//                                 child: Icon(
//                                   Icons.image,
//                                   size: 40,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextField(
//                       controller: descriptionController,
//                       maxLines: 4,
//                       textAlignVertical: TextAlignVertical.top,
//                       decoration: InputDecoration(
//                         labelText: 'description',
//                         alignLabelWithHint: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFE53935),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadiusGeometry.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     "cancel",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//                 SizedBox(width: 60),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final path = _imageFile?.path;
//                     final url = await UploadImg().uploadImage(path ?? "");
//                     final uploadData = {
//                       "words": wordController.text,
//                       "level": widget.title,
//                       "pos": "", // ถ้ามีประเภทคำ (noun, adj) ให้ใส่
//                       "description": descriptionController.text,
//                       "image_url": url, // รูปที่เลือก
//                       "default": "false",
//                     };

//                     UploadTofirestore().upload(
//                       uploadData,
//                       Storage().getUserId(),
//                       widget.title,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF4CAF50),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadiusGeometry.circular(8),
//                     ),
//                   ),
//                   child: SizedBox(
//                     width: 40,
//                     child: Center(
//                       child: Text(
//                         "ok",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
