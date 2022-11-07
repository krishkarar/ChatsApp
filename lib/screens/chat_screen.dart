// import 'package:flutter/material.dart';
// import 'package:chatsapp/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// final _firestore = FirebaseFirestore.instance;
// late User loggedinUser;
// final _auth = FirebaseAuth.instance;
//
// void getCurrentUser() async {
//   try {
//     final user = await _auth.currentUser;
//     if (user != null) {
//       loggedinUser = user;
//       print(loggedinUser.email);
//     }
//   } catch (e) {
//     print(e);
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   static String id = 'chat_screen';
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late String messageText;
//   final messageTextController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     getCurrentUser();
//   }
//
//   // void getMessages()async{
//   //   final messages = await _firestore.collection('messages').get();
//   //
//   //   for(var message in messages.docs){
//   //     print(message.data());
//   //   }
//   // }
//
//   void getMessageStream() async {
//     await for (var snapshot in _firestore.collection('messages').snapshots()) {
//       for (var message in snapshot.docs) {
//         print(message.data());
//       }
//     }
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 //Implement logout functionality
//                 _auth.signOut();
//                 Navigator.pop(context);
//                 // getMessageStream();
//               }),
//         ],
//         title: Text('⚡️Chat'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             MessageStream(),
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: messageTextController,
//                       onChanged: (value) {
//                         //Do something with the user input.
//                         messageText = value;
//                       },
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       //Implement send functionality.
//                       messageTextController.clear();
//                       _firestore.collection('messages').add({
//                         'text': messageText,
//                         'sender': loggedinUser.email,
//                       });
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MessageStream extends StatelessWidget {
//   const MessageStream({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('messages').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.blueAccent,
//             ),
//           );
//         }
//         final messages = snapshot.data?.docs.reversed;
//         List<MessageBubble> messageBubbles = [];
//
//         for (var message in messages!) {
//           final messageText = message.get('text');
//           final messageSender = message.get('sender');
//           final currentUser = loggedinUser.email;
//
//           final messageBubble = MessageBubble(
//             sender: messageSender,
//             text: messageText,
//             isMe: currentUser == messageSender,
//           );
//
//           messageBubbles.add(messageBubble);
//         }
//         return Expanded(
//           child: ListView(
//             reverse: true,
//             padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//             children: messageBubbles,
//           ),
//         );
//       },
//     );
//   }
// }
//
// class MessageBubble extends StatelessWidget {
//   // const ({Key? key}) : super(key: key);
//
//   MessageBubble({required this.sender, required this.text, required this.isMe});
//
//   final String text;
//   final String sender;
//   final bool isMe;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender,
//             style: TextStyle(fontSize: 11.0, color: Colors.blueGrey),
//           ),
//           Material(
//             borderRadius: isMe
//                 ? BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0))
//                 : BorderRadius.only(
//                     topRight: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0)),
//             elevation: 8.0,
//             color: isMe ? Colors.blueAccent : Colors.blueGrey,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:chatsapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextContoller = TextEditingController();
  final _auth = FirebaseAuth.instance;


  late String messageText;



  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // _numberCtrl.text = '+917028640462';
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
          // IconButton(
          //   onPressed: () async{
          //     await FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
          //   },
          //   icon: Icon(Icons.call),
          //   color: Colors.white,
          // ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextContoller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextContoller.clear();
                      _firestore.collection("messages").add({
                        "text": messageText,
                        "sender": loggedInUser.email,
                        "time": DateTime.now()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  // TextButton(onPressed: () async{
                  //   // final result = await FilePicker.platform.pickFiles();
                  //
                  // }, child: Icon(Icons.attach_file)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("messages").snapshots(),
    // ignore: missing_return
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.lightBlueAccent,
    ),
    );
    }
    final messages = snapshot.data?.docs;
    List<MessageBubble> messageBubbles = [];
    for (var message in messages!) {
      final messageText = message['text'];
      final messageSender = message["sender"];
      final messageTime = message["time"];
      final currentUser = loggedInUser.email;
      final messageBubble = MessageBubble(
        sender: messageSender,
        text: messageText,
        time: messageTime,
        isMe: currentUser == messageSender,
      );
      messageBubbles.add(messageBubble);
      messageBubbles.sort((a, b) => b.time.compareTo(a.time));
    }
    return Expanded(
      child: ListView(
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        children: messageBubbles,
      ),
    );
    },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp time;
  final bool isMe;

  MessageBubble({required this.sender, required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$sender ${time.toDate()}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )
                : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}