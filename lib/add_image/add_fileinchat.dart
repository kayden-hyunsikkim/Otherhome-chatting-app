import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_auth/firebase_auth.dart'; //for user authentication
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFile extends StatefulWidget {
  const AddFile(this.addFileFunc, this.selectedNumber, {Key? key})
      : super(key: key);

  final Function(File PickedFile)
      addFileFunc; // put picked image into function to transfer to main screen page
  final int selectedNumber;

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  File? pickedImage;
  File? userPickedImage;

  File? pickedFile;
  File? userPickedFile;

  late String _houseNumber = '';
  late String userName = '';

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Allow picking only one file.
      type: FileType.custom, // Specify the type of files you want to pick.
      allowedExtensions: [
        'pdf',
        'doc',
        'txt'
      ], // List of allowed file extensions.
    );

    setState(() async{
      if (result != null)  {
        pickedFile = File(result.files.single.path!);
        userPickedFile =
            pickedFile; // Add this line to assign pickedImage to userPickedImage
      }
    });
    print(userPickedFile);
    print(pickedFile);

    widget.addFileFunc(
        pickedFile!); // put picked image into function to transfer to main screen page
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: 150,
      height: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.lightGreen,
            backgroundImage:
            pickedFile != null ?  FileImage(File(pickedFile!.path)) // Convert File to ImageProvider
        : null,
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: () {
              _pickFile();
            },
            icon: Icon(Icons.file_copy),
            label: Text('Upload Your file'),
          ),
          SizedBox(
            height: 80,
          ),
          TextButton.icon(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              final userDoc =
                  FirebaseFirestore.instance.collection('user').doc(user!.uid);
              print(userDoc);
              userDoc.get().then((docSnapshot) async {
                if (docSnapshot.exists) {
                  print(docSnapshot.exists);
                  final userData = docSnapshot.data();
                  if (userData != null &&
                      user!.uid == "yVXgbr1mh0Q1Osg72NzmQhtjwFm2") {
                    print('working');
                    print(widget.selectedNumber);
                    String _houseNumber =
                        widget.selectedNumber.toString(); // houseNumber 값 가져오기
                    String userName = userData['userName'];
                    print(_houseNumber);
                    if (user != null && userPickedImage != null) {
                      // Add null check for userPickedImage
                      final refImage = FirebaseStorage.instance
                          .ref()
                          .child('usersend_picture')
                          .child(userName)
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString() +
                                  '.png');
                      //to store picked profile picture into firebase storage

                      await refImage.putFile(userPickedImage!);
                      final url = await refImage.getDownloadURL();
                      print(url);

                      // Firestore에 채팅 메시지 데이터 저장
                      await FirebaseFirestore.instance
                          .collection(_houseNumber)
                          .add({
                        'text': url,
                        'userID': user.uid,
                        'userName': userName,
                        'userImage': userData['profilePicture'],
                        'sentImage': url,
                        'time': FieldValue.serverTimestamp(),
                        // 서버 시간으로 메시지 시간 저장
                      });
                    }

                    print(userData != null &&
                        user!.uid != "yVXgbr1mh0Q1Osg72NzmQhtjwFm2");
                    Navigator.pop(context);
                  }
                  if (userData != null &&
                      user!.uid != "yVXgbr1mh0Q1Osg72NzmQhtjwFm2") {
                    print('working');
                    print(userData['houseNumber']);
                    print(userData['userName']);
                    String _houseNumber =
                        userData['houseNumber']; // houseNumber 값 가져오기
                    String userName = userData['userName'];
                    print(_houseNumber);
                    if (user != null && userPickedImage != null) {
                      // Add null check for userPickedImage
                      final refImage = FirebaseStorage.instance
                          .ref()
                          .child('usersend_picture')
                          .child(userName)
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString() +
                                  '.png');
                      //to store picked profile picture into firebase storage

                      await refImage.putFile(userPickedImage!);
                      final url = await refImage.getDownloadURL();
                      print(url);

                      // Firestore에 채팅 메시지 데이터 저장
                      await FirebaseFirestore.instance
                          .collection(_houseNumber)
                          .add({
                        'text': url,
                        'userID': user.uid,
                        'userName': userName,
                        'userImage': userData['profilePicture'],
                        'sentImage': url,
                        'time': FieldValue.serverTimestamp(),
                        // 서버 시간으로 메시지 시간 저장
                      });
                    }
                  }
                  Navigator.pop(context);
                }
              }).catchError((error) {
                print('Error fetching user document: $error');
              });

              print(_houseNumber);
            },
            icon: Icon(Icons.close),
            label: Text('Send'),
          ),
        ],
      ),
    );
  }
}
