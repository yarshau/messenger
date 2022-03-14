import 'package:flutter/material.dart';
import 'package:yar_messenger/firebase_api.dart';

class MessagingPage extends StatefulWidget {
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final messageController = TextEditingController();
  final firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                Container(width: 200,
                  child: TextField(decoration: InputDecoration(labelText: 'Message'),
                    controller: messageController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      firebaseApi.sendMessage(messageController.text);
                    },
                    child: Text('Send'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
