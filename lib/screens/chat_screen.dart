import 'package:chat/widgets/chat/messages.dart';
import 'package:chat/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          DropdownButton(
            borderRadius: BorderRadius.circular(10),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.secondary,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text('Logout'),
                        content:
                            const Text('Are you sure you want to logout ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop('No');
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop('Yes');
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    }).then((value) {
                  if (value == 'Yes') {
                    FirebaseAuth.instance.signOut();
                  } else {
                    return;
                  }
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
