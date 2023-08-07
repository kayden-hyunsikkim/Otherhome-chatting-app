import 'package:chatrefer/chatting/chat/new_housemessage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatrefer/chatting/chat/housemessage.dart';



class HouseChatScreen extends StatefulWidget {
  final int selectedNumber; // Add this line to receive the selected number

  HouseChatScreen({required this.selectedNumber, Key? key}) : super(key: key);

  @override
  _HouseChatScreenState createState() => _HouseChatScreenState();
}

class _HouseChatScreenState extends State<HouseChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  int _selectedNumber = 1; // 여기에서 받아야함

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedNumber = widget.selectedNumber;
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
        title: Text('House Chat screen'),

      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: HouseMessages(selectedNumber: widget.selectedNumber), // 선택한 번호를 전달
            ),
            NewHouseMessage(selectedNumber: widget.selectedNumber),
          ],
        ),
      ),
    );
  }
}