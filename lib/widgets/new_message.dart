import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//final fireStore = FirebaseFirestore.instance;
class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    // To get current user
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get(); // Get method is used to retrieve data from firebase

    //Send Message To firebase
    FirebaseFirestore.instance.collection('chat').add({
      "text":enteredMessage,
      "created at": Timestamp.now(),
      "userId": user.uid,
      "username": userData.data()!['username'],
      "userImage": userData.data()!['imageUrl']
    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color(0xFFFFFFFF),
      ),
      height: 70,

      margin: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
      child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(labelText: "Send a Message"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: IconButton(
                  splashRadius: 15.0,
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(
                    Icons.send_rounded,color: Color.fromARGB(255, 10, 20, 148),size: 35.0,),
                  onPressed: _submitMessage,
                ),
              )
            ],
          )),
    );
  }
}
