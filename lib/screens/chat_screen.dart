import 'package:chatrefer/chatting/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatrefer/chatting/chat/message.dart';


class ChatScreen extends StatefulWidget {
  final String? selecteduserName; // selecteduserName 변수를 추가

  ChatScreen({Key? key, this.selecteduserName}) : super(key: key); // 생성자에 해당 변수를 추가하고 초기화

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  String? _selecteduserName = ''; // 초기 userName (dummy data임)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selecteduserName = widget.selecteduserName;
    getCurrentUser();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice from Admin'),

      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(selecteduserName: _selecteduserName),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}