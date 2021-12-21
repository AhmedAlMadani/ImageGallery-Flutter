import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_image_gallery/view/upload_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Widget buildUploadButton() => FloatingActionButton(
      backgroundColor: Colors.deepPurple[100],
      child: const Icon(
        Icons.add_a_photo,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UploadScreen()));
      });

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firebaseFirestore.collection("images").snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasError
                        ? Center(
                            child: Text(
                                "There is some problem loading your images"),
                          )
                        : snapshot.hasData
                            ? GridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 1,
                                childAspectRatio: 1,
                                children: snapshot.data!.docs
                                    .map((e) => Image.network(e.get("url")))
                                    .toList(),
                              )
                            : Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildUploadButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
