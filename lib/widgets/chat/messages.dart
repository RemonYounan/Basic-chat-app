import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // <QuerySnapshot> this is important! <=
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = streamSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: MessageBubble(
              chatDocs[i]['text'],
              chatDocs[i]['username'],
              chatDocs[i]['userImage'],
              chatDocs[i]['userid'] == FirebaseAuth.instance.currentUser!.uid,
              key: ValueKey(
                chatDocs[i].id,
              ),
            ),
          ),
        );
      },
    );
  }
}
