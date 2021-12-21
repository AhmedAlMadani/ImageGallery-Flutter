// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view/gallery_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  List<UploadTask> uploadedTasks = [];

  List<File> selectedFiles = [];

  uploadFileToStorage(File file) {
    UploadTask task = _firebaseStorage
        .ref()
        .child("images/${DateTime.now().toString()}")
        .putFile(file);
    return task;
  }

  writeImageUrlToFireStore(imageUrl) {
    _firebaseFirestore.collection("images").add({"url": imageUrl}).whenComplete(
        () => print("$imageUrl is saved in Firestore"));
  }

  saveImageUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref
            .getDownloadURL()
            .then((imageUrl) => writeImageUrlToFireStore(imageUrl));
      }
    });
  }

  Future selectFileToUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (result != null) {
        selectedFiles.clear();

        for (var selectedFile in result.files) {
          File file = File(selectedFile.path.toString());
          selectedFiles.add(file);
        }

        for (var file in selectedFiles) {
          final UploadTask task = uploadFileToStorage(file);
          saveImageUrlToFirebase(task);

          setState(() {
            uploadedTasks.add(task);
          });
        }
      } else {
        print("User has cancelled the selection");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        foregroundColor: Colors.black,
        title: Text(
          'Upload History',
          style: GoogleFonts.getFont(
            'Sen',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[100],
        onPressed: () {
          selectFileToUpload();
        },
        child: Icon(
          Icons.upload,
          color: Colors.black,
        ),
      ),
      body: uploadedTasks.length == 0
          ? Center(
              child: Text(
              "Please tap on add button to upload images",
              style: GoogleFonts.getFont('Sen'),
            ))
          : ListView.separated(
              itemBuilder: (context, index) {
                return StreamBuilder<TaskSnapshot>(
                  builder: (context, snapShot) {
                    return snapShot.hasError
                        ? Text(
                            "There is some error in uploading file",
                            style: GoogleFonts.getFont('Sen'),
                          )
                        : snapShot.hasData
                            ? ListTile(
                                title: Text(
                                    "${snapShot.data!.bytesTransferred}/${snapShot.data!.totalBytes} ${snapShot.data!.state == TaskState.success ? "Completed" : snapShot.data!.state == TaskState.running ? "In Progress" : "Error"}"),
                              )
                            : Container();
                  },
                  stream: uploadedTasks[index].snapshotEvents,
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: uploadedTasks.length,
            ),
    );
  }
}
