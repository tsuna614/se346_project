import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se346_project/src/api/generalAPI.dart';
import 'package:se346_project/src/data/types.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _firebase = FirebaseAuth.instance;

  Future<UserProfileData?> getUserData(String userId) async {
    return GeneralAPI().loadOtherProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = _firebase.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          const Text("Friend requests"),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('receiver', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No notifications"),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final notification = snapshot.data!.docs[index];
                    return FutureBuilder(
                      future: getUserData(notification['sender']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final user = snapshot.data as UserProfileData;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(user.name),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.avatarUrl!),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          GeneralAPI().addFriend(
                                              currentUserId, user.id);
                                          GeneralAPI().removeNotification(
                                              notification.id);
                                          setState(() {});
                                        },
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          GeneralAPI().removeNotification(
                                              notification.id);
                                        },
                                        child: const Text(
                                          "Decline",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
