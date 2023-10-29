import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageUpload extends StatefulWidget {
  final String? userId;
  const ImageUpload({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No File selected", const Duration(seconds: 5));
      }
    });
  }

  Future uploadImage(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('${widget.userId}/images')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(() =>
            showSnackBar("Image Upload Completed", const Duration(seconds: 5)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Image",
          style: GoogleFonts.getFont('Sen',
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Upload Image",
                    style: GoogleFonts.getFont('Sen',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.indigo),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _image == null
                                  ? Center(
                                      child: Text("No image selected",
                                          style: GoogleFonts.getFont('Sen',
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal)))
                                  : Image.file(_image!),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  imagePickerMethod();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.indigo),
                                ),
                                child: Text(
                                  "Select Image",
                                  style: GoogleFonts.getFont(
                                    'Sen',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_image != null) {
                                    uploadImage(_image!);
                                  } else {
                                    showSnackBar("Select Image first",
                                        const Duration(seconds: 5));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.indigo),
                                ),
                                child: Text(
                                  "Upload Image",
                                  style: GoogleFonts.getFont(
                                    'Sen',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
