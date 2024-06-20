import 'package:chitchat/widgets/chat_messages.dart';
import 'package:chitchat/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF5E62),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          title: Text(
            "ChitChat",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 1.2,
            ),
          ),

          actions: <Widget>[

            IconButton(
              onPressed: () {
                _firebase.signOut();
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.black87,
              ),
            ),
            const Text("LogOut" , style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black87
            ),),
            const SizedBox(width: 10,),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [Colors.black87 , Colors.white54,Colors.grey],
            //       begin: Alignment.topLeft,
            //   end: Alignment.bottomRight
            // )

          //


            gradient: LinearGradient(
              colors: [
                Color(0xFFFF5E62), // Red
                Color(0xFFFF9966), // Orange
                Color(0xFFFFC371), // Light Orange
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            //
    //       gradient: RadialGradient(
    //       colors: [
    //     Color(0xFF1A1A2E), // Dark Navy
    // Color(0xFF16213E), // Dark Blue
    // ],
    // center: Alignment.center,
    // radius: 0.8,),),


          ),
          child: const Column(
            children: [
              //Expanded Widget so that its child can take as much width it requires
              Expanded(
                  child: ChatMessages()
              ),

              NewMessage()
            ],
          ),
        ));
  }
}
