import 'package:chatrefer/chatting/chat/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class HouseMessages extends StatefulWidget {
  final int selectedNumber; // 추가: 선택한 번호를 받아오는 매개변수

  HouseMessages({required this.selectedNumber}); // 생성자 추가


  @override
  _HouseMessageState createState() => _HouseMessageState();
}


class _HouseMessageState extends State<HouseMessages> {
  late String _houseNumber;
  bool _isLoading = true;

  bool _isAdminUser(String currentUserID) {
    String adminUserID = "yVXgbr1mh0Q1Osg72NzmQhtjwFm2";
    return currentUserID == adminUserID;
  }

  int? _selectedNumber;

  @override
  void initState() {
    super.initState();
    _selectedNumber = widget.selectedNumber; // 선택한 번호 초기화
    _initializeData();
  }



  Future<void> _initializeData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    if (_isAdminUser(user!.uid)) {
      var _newhouseNumber = _selectedNumber.toString();
      _houseNumber = _newhouseNumber; // 선택한 번호에 맞는 house number로 설정
    } else {
      _houseNumber = userData.data()!['houseNumber']; // 일반 유저의 경우 이전과 같이 설정
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(_houseNumber)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            final chatData = chatDocs[index].data();
            final time = chatData['time'] as Timestamp;
            final formattedTime =
            DateFormat('       MM-dd hh:mm a       ').format(time.toDate());

            return Column(
              crossAxisAlignment:
              chatDocs[index]['userID'].toString() == user!.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                ChatBubbles(
                    chatDocs[index]['text'],
                    chatDocs[index]['userID'].toString() == user!.uid,
                    chatDocs[index]['userName'],
                    chatDocs[index]['userImage']),
                SizedBox(height: 8),
                Text(
                  formattedTime.substring(0, formattedTime.length),
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}
