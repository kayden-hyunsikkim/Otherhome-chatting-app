import 'package:chatrefer/chatting/chat/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  final String? selecteduserName; // 사용자 이름을 저장할 변수

  Messages({required this.selecteduserName}); // 생성자 추가

  bool isAdminUser(String currentUserID) {
    String adminUserID = "yVXgbr1mh0Q1Osg72NzmQhtjwFm2";
    return currentUserID != adminUserID;
  }

  bool isSelectedNameAdmin(String selectedTenant) {
    return selecteduserName == '';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final currentUserID = user?.uid ?? '';
    final selectedTenant = '';

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admin')
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

            final isSelectednameAdmin = isSelectedNameAdmin(selectedTenant);
            print(selecteduserName);

            final isAdmin = isAdminUser(currentUserID);
            print(currentUserID);
            print(chatDocs[index]['userID'].toString());
            print(isAdmin);

            {
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
                    chatDocs[index]['userImage'],

                  ),
                  SizedBox(height: 8),
                  if (chatDocs[index].data().containsKey('sentImage')) // 'sentImage' 필드가 있는지 확인
                    Image.network(
                      chatDocs[index]['sentImage'], // 이미지 URL 가져와서 표시
                      width: 250, // 이미지의 크기를 조절하거나 원하는대로 스타일링 가능
                      height: 200,
                    ),
                  Text(
                    formattedTime.substring(0, formattedTime.length),
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 8),
                ],
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
