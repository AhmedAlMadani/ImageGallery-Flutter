// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  final picker = ImagePicker();

  Widget buildUploadButton() => FloatingActionButton(
      backgroundColor: Colors.deepPurple[100],
      child: const Icon(
        Icons.add_a_photo,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: () {
        dialogBox();
      });

  Future takePhoto() async {
    final PickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      image = File(PickedFile!.path);
    });
  }

  Future getPhoto() async {
    final PickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = File(PickedFile!.path);
    });
  }

  Future<void> dialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Take Photo',
                      style: GoogleFonts.getFont('Sen', fontSize: 18),
                    ),
                    onTap: takePhoto,
                  ),
                  GestureDetector(
                    child: Text(
                      'Pick from device',
                      style: GoogleFonts.getFont('Sen', fontSize: 18),
                    ),
                    onTap: getPhoto,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Text(
              'Gallery',
              style: GoogleFonts.getFont('Sen',
                  fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: image == null
                  ? Text(
                      'No image',
                      style: GoogleFonts.getFont('Sen', fontSize: 18),
                    )
                  : Image.file(image!),
            ))
          ],
        ),
      ),
      floatingActionButton: buildUploadButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
