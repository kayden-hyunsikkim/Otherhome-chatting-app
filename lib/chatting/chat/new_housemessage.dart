import 'package:chatrefer/add_image/add_fileinchat.dart';


import 'dart:io';
import 'package:chatrefer/add_image/add_imageinchat.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewHouseMessage extends StatefulWidget {
  final int selectedNumber; // 추가: 선택한 번호를 받아오는 매개변수
  const NewHouseMessage({required this.selectedNumber,Key? key}) : super(key: key);

  @override
  State<NewHouseMessage> createState() => _NewHouseMessageState();
}

class _NewHouseMessageState extends State<NewHouseMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  File? userPickedImage;
  File? userFileImage;


  void pickedImage(File image) {
    userPickedImage = image;
  }

  void pickedFile(File file) {
    userFileImage = file;
  }

  void _sendMessage() async {
    print(_userEnterMessage);
    print(widget.selectedNumber);
    FocusScope.of(context).unfocus(); // hide keyboard after sending message
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    print(user.uid);
    if (user!.uid == "yVXgbr1mh0Q1Osg72NzmQhtjwFm2") {
      print('hi');
      print(_userEnterMessage);
      print(widget.selectedNumber);
      String selectedNumber = widget.selectedNumber.toString();
      print(selectedNumber);
      print(userData.data()!['userName']);
      print(userData['profilePicture']);
      print(Timestamp.now());


      FirebaseFirestore.instance
          .collection(selectedNumber)
          .add({
        'text': _userEnterMessage,
        'time': Timestamp.now(),
        'userID': user!.uid,
        'userName': userData.data()!['userName'],
        'userImage': userData['profilePicture']
      });
    } else {
      FirebaseFirestore.instance
          .collection(userData.data()!['houseNumber'])
          .add({
        'text': _userEnterMessage,
        'time': Timestamp.now(),
        'userID': user!.uid,
        'userName': userData.data()!['userName'],
        'userImage': userData['profilePicture']
      });
    }

    _controller.clear();
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: AddImage(pickedFile, widget.selectedNumber),
        );
      },
    );
  }

  void showAlertforFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: AddFile(pickedFile, widget.selectedNumber),
        );
      },
    );
  }
  @override

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          GestureDetector(
            child: IconButton(
              onPressed: () {
                showAlert(context);
              },
              icon: Icon(Icons.image),
              color: Colors.lightGreen,
            ),
          ),
          GestureDetector(
            child: IconButton(
              onPressed: () {
                showAlertforFile(context);
              },
              icon: Icon(Icons.file_copy),
              color: Colors.lightGreen,
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.lightGreen,
          ),
        ],
      ),
    );
  }
}
