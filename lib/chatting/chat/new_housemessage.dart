import 'package:firebase_core/firebase_core.dart';
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
