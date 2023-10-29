import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageRetrive extends StatefulWidget {
  final String? userId;
  const ImageRetrive({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageRetrive> createState() => _ImageRetriveState();
}

class _ImageRetriveState extends State<ImageRetrive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Images",
          style: GoogleFonts.getFont('Sen',
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .collection("images")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (Center(
                child: Text("No Images Found",
                    style: GoogleFonts.getFont('Sen',
                        fontSize: 15, fontWeight: FontWeight.normal))));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String url = snapshot.data!.docs[index]['downloadURL'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    url,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
