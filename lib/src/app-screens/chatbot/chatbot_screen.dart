import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:se346_project/src/app-screens/chatbot/message_bubble.dart';
import 'package:se346_project/src/provider/user_provider.dart';
import 'package:se346_project/src/utils/custom_clip_path.dart';
import 'package:se346_project/src/data/global_data.dart' as globals;

class ChatScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const ChatScreen({super.key, required this.alternateDrawer});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  late String _currentUserId;
  final String targetUserId = "chatbot";

  int currentChosenMessage = -1;

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _sendMessage(String senderId, String receiverId) async {
    final userText = _messageController.text;

    _submitMessage(senderId, receiverId, _messageController.text);

    final _dio = Dio();

    Response response = await _dio.post(
      '${globals.baseUrl}/user/generateAnswer',
      data: {
        "message": userText,
      },
    );

    _submitMessage(receiverId, senderId, response.data[0]);
  }

  void _submitMessage(
      String senderId, String receiverId, String message) async {
    final enteredMessage = message;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    final db = FirebaseFirestore.instance;

    // look in the chat collection for a document that has a "users" map that contains both the current user and the target user's id
    await db
        .collection("chat")
        .where("users.$senderId", isEqualTo: true)
        .where("users.$receiverId", isEqualTo: true)
        .get()
        .then(
      (value) {
        // if a document is found, add the message to the messages collection of that document
        if (value.docs.isNotEmpty) {
          db
              .collection("chat")
              .doc(value.docs[0].id)
              .collection("messages")
              .add({
            "message": enteredMessage,
            "createdAt": Timestamp.now(),
            "userId": senderId,
          });
          // if no document was found, create new one, then add the message
        } else {
          db.collection("chat").add({
            "users": {
              senderId: true,
              receiverId: true,
            },
          }).then((value) {
            db.collection("chat").doc(value.id).collection("messages").add({
              "message": enteredMessage,
              "createdAt": Timestamp.now(),
              "userId": senderId,
            });
          });
        }
      },
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    _currentUserId = Provider.of<UserProvider>(context, listen: false).userId;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
            child: FutureBuilder(
                future: buildTextMessages(context),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No messages found.'),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong...'),
                    );
                  }

                  return snapshot.data!;
                }),
          ),
          ClipPath(
            clipper: AppBarClipPath(context: context, height: 1),
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                // gradient
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.blueAccent.shade200,
                    Colors.blue.shade700,
                  ],
                ),
              ),
            ),
          ),
          buildAppBarNameCard(context),
          buildBottomTextArea(context),
        ],
      ),
    );
  }

  Widget buildAppBarNameCard(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    widget.alternateDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 20,
              ),
              const SizedBox(
                width: 200,
                child: Text(
                  "Chat Bot Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Container()),
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.ellipsisVertical),
                color: Colors.white,
              ),
            ],
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Future<String> _getChatId() async {
    String chatId = "";

    await FirebaseFirestore.instance
        .collection("chat")
        .where("users.$_currentUserId", isEqualTo: true)
        .where("users.$targetUserId", isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        chatId = value.docs[0].id;
      }
    });

    return chatId;
  }

  final ValueNotifier<int> _notifier = ValueNotifier(-1);

  Future<Widget> buildTextMessages(BuildContext context) async {
    String chatId = "";
    chatId = await _getChatId();

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          // return ListView.builder(
          //   reverse: true,
          //   itemCount: loadedMessages.length,
          //   itemBuilder: (context, index) {
          //     final chatMessage = loadedMessages[index].data();

          //     return GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           currentChosenMessage = index;
          //         });
          //       },
          //       child: MessageBubble(
          //         message: chatMessage["message"],
          //         isCurrentUser: chatMessage["userId"] == _currentUserId,
          //         isChosenMessage: currentChosenMessage == index,
          //       ),
          //     );
          //   },
          // );

          return ValueListenableBuilder(
              valueListenable: _notifier,
              builder: ((context, value, child) {
                return ListView.builder(
                    reverse: true,
                    itemCount: loadedMessages.length,
                    itemBuilder: (context, index) {
                      final chatMessage = loadedMessages[index].data();

                      Timestamp timestamp = chatMessage["createdAt"];

                      // convert timestamp to DateTime
                      DateTime dateTime = timestamp.toDate();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            if (_notifier.value == index) {
                              _notifier.value = -1;
                            } else {
                              _notifier.value = index;
                            }
                          },
                          child: MessageBubble(
                            message: chatMessage["message"],
                            isCurrentUser:
                                chatMessage["userId"] == _currentUserId,
                            isChosenMessage: _notifier.value == index,
                            createdTime: dateTime,
                          ),
                        ),
                      );
                    });
              }));
        });
  }

  Widget buildBottomTextArea(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _sendMessage(_currentUserId, targetUserId);
              },
              icon: Icon(Icons.send),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
