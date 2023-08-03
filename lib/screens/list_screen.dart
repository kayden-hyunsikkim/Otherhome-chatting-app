import 'package:chatrefer/screens/housechat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatrefer/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';


// Git hub upload check - 잘될시 지울예정

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  int _selectedNumber = 1; // 초기값은 1로 설정
  String? _selecteduserName = 'admin'; // 초기 userName (dummy data임)

  List<String> _usernames = []; // 사용자 정보를 담을 리스트
  List<String> _housenumbers = []; // 사용자 정보를 담을 리스트

  bool _isAdminUser() {
    String adminUserID = "yVXgbr1mh0Q1Osg72NzmQhtjwFm2";
    return loggedUser?.uid == adminUserID;
  }

  @override
  void _launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch $_emailLaunchUri';
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    fetchUsernames();
  }

  void getCurrentUser() async {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
        final userData = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();
        setState(() {
          _selectedNumber =
              userData.data()?['houseNumber']; // user 정보의 house number를 할당
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchUsernames() async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('user');
      final userDocs = await userCollection.get();

      setState(() {
        _housenumbers =
            userDocs.docs.map((doc) => doc['houseNumber'] as String).toList();
        _usernames =
            userDocs.docs.map((doc) => doc['userName'] as String).toList();
      });
      print(_housenumbers);
      print(_usernames);
    } catch (e) {
      print('Error fetching usernames: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat list'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                _authentication.signOut();
              },
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            if (_isAdminUser()) {
              // Only pass the selected number if the user is an admin
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HouseChatScreen(selectedNumber: _selectedNumber)),
              );
            } else {
              // For non-admin users, just navigate to HouseChatScreen without passing the selected number
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HouseChatScreen(selectedNumber: _selectedNumber)),
              );
            }
          },
          child: Column(
            children: [
              if (!_isAdminUser()) // when current user id is normal user id
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            )
                          ]),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                child: Text(
                                  'With House Mates',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                padding: EdgeInsets.all(30),
                                width: MediaQuery.of(context).size.width - 40,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        Text('details details details '),
                                        SizedBox(height: 20),
                                        Text('details details details '),
                                        SizedBox(height: 20),
                                        Text('details details details '),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (_isAdminUser()) // when current user id is admin user id
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                      height: 250,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            )
                          ]),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                child: Text(
                                  'See house chats',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                padding: EdgeInsets.all(30),
                                width: MediaQuery.of(context).size.width - 40,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        DropdownButton<int>(
                                          value: _selectedNumber,
                                          onChanged: (int? newValue) {
                                            setState(() {
                                              _selectedNumber = newValue ?? 1;
                                              print(_selectedNumber);
                                            });
                                          },
                                          items: List.generate(10, (index) {
                                            return DropdownMenuItem<int>(
                                              value: index + 1,
                                              child:
                                                  Text((index + 1).toString()),
                                            );
                                          }),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(selecteduserName: _selecteduserName)),
                  );
                },
                child: Column(
                  children: [
                    if (!_isAdminUser()) // when current user id is normal user id
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              )
                            ]),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Text(
                                    'Notice from Admin',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  padding: EdgeInsets.all(30),
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 45,
                                        backgroundColor: Colors.lightGreen,
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text('details details details '),
                                          SizedBox(height: 20),
                                          Text('details details details '),
                                          SizedBox(height: 20),
                                          Text('details details details '),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    if (_isAdminUser()) // when current user id is normal user id
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              )
                            ]),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Text(
                                    'To Tenant',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  padding: EdgeInsets.all(30),
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.lightGreen,
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text('details details details '),
                                          SizedBox(height: 20),
                                          Text('details details details '),
                                          SizedBox(height: 20),
                                          Text('details details details '),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    if (!_isAdminUser())
                    Column(
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchEmail('example1@example.com');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CS Inquiry  :',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'example1@example.com',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchEmail('example2@example.com');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Maintence Inquiry  :',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'example2@example.com',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
