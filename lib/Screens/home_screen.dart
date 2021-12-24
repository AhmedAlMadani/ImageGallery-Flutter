import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'login_screen.dart';
import '../Controller/image_upload_controller.dart';
import '../Controller/image_retrive_controller.dart';
import '../Model/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 130),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Welcome",
                      style: GoogleFonts.getFont('Sen',
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                      style: GoogleFonts.getFont('Sen',
                          fontSize: 15, fontWeight: FontWeight.normal)),
                  Text("${loggedInUser.email}",
                      style: GoogleFonts.getFont('Sen',
                          fontSize: 15, fontWeight: FontWeight.normal)),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageUpload(
                                    userId: loggedInUser.uid,
                                  )));
                    },
                    child: Text(
                      "Upload Image",
                      style: GoogleFonts.getFont('Sen',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple[200]),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple[200]),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImageRetrive(userId: loggedInUser.uid)));
                    },
                    child: Text("Show Uploads",
                        style: GoogleFonts.getFont('Sen',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
            title: Text("Profile",
                style: GoogleFonts.getFont(
                  'Sen',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            backgroundColor: Colors.deepPurple[200],
            actions: [
              IconButton(
                  onPressed: () {
                    logout(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  )),
            ]));
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
