import 'package:firebase_core/firebase_core.dart';

import 'dart:io';
import 'package:chatrefer/add_image/add_imageinchat.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewHouseMessage extends StatefulWidget {
  const NewHouseMessage({Key? key}) : super(key: key);

  @override
  State<NewHouseMessage> createState() => _NewHouseMessageState();
}

class _NewHouseMessageState extends State<NewHouseMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  File? userPickedImage;

  void pickedImage(File image) {
    userPickedImage = image;
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus(); // hide keyboard after sending message
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    FirebaseFirestore.instance.collection(userData.data()!['houseNumber']).add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user!.uid,
      'userName' : userData.data()!['userName'],
      'userImage' : userData['profilePicture']
    });
    _controller.clear();
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: AddImage(pickedImage),
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
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.file_copy),
            color: Colors.lightGreen,
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
