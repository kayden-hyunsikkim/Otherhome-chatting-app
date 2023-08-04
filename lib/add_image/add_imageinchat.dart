import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'; //for user authentication
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddImage extends StatefulWidget {
  const AddImage(this.addImageFunc, {Key? key}) : super(key: key);

  final Function(File PickedImage) addImageFunc; // put picked image into function to transfer to main screen page

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  File? pickedImage;
  File? userPickedImage;
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

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 150); //add image from gallery

    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
        userPickedImage = pickedImage; // Add this line to assign pickedImage to userPickedImage
      }
    });

    widget.addImageFunc(pickedImage!); // put picked image into function to transfer to main screen page
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
            backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: () {
              _pickImage();
            },
            icon: Icon(Icons.image),
            label: Text('Upload picture'),
          ),
          SizedBox(
            height: 80,
          ),
          TextButton.icon(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final userDoc = FirebaseFirestore.instance.collection('user').doc(user!.uid);
              userDoc.get().then((docSnapshot) async {
                if (docSnapshot.exists) {
                  final userData = docSnapshot.data();
                  if (userData != null) {
                    String _houseNumber = userData['houseNumber']; // houseNumber 값 가져오기
                    String userName =  userData['userName'];
                    print(_houseNumber);
                    if (user != null && userPickedImage != null) { // Add null check for userPickedImage
                      final refImage = FirebaseStorage.instance
                          .ref()
                          .child('usersend_picture')
                          .child(user.uid + 'png');
                      //to store picked profile picture into firebase storage

                      await refImage.putFile(userPickedImage!);
                      final url = await refImage.getDownloadURL();
                      print(url);

                      // Firestore에 채팅 메시지 데이터 저장
                      await FirebaseFirestore.instance.collection(_houseNumber).add({
                        'text' : url,
                        'userID': user.uid,
                        'userName': userName,
                        'userImage': userData['profilePicture'],
                        'sentImage': url,
                        'time': FieldValue.serverTimestamp(), // 서버 시간으로 메시지 시간 저장
                      });


                    } else {
                      print("User or userPickedImage is null.");
                    }
                    Navigator.pop(context);
                  }
                } else {
                  print('User document does not exist in Firestore.');
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
