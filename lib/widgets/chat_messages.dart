import 'package:chitchat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {

    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chat').orderBy('created at',descending: true).snapshots(),  // This snapshot notifies whenever a new message is added to a collection and builder does following work
          builder: (ctx , chatSnapShots ){
            if(chatSnapShots.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(!chatSnapShots.hasData || chatSnapShots.data!.docs.isEmpty){
              return const Center(
                child:Text("No messages found"),
              );
            }

            if(chatSnapShots.hasError){
              return const Center(
                child:Text("Something went wrong"),
              );
            }

            final loadMessages = chatSnapShots.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40,left: 13,right: 13),
                reverse: true, // Messages move from bottom to top
                itemCount: loadMessages.length ,
                itemBuilder: (ctx , index){
                 final chatMessage = loadMessages[index].data();
                 final nextChatMessage = index + 1 < loadMessages.length ? loadMessages[index+1].data() : null;

                 final currentMessageUserId = chatMessage['userId'];
                 final nextMessageUserId =  nextChatMessage!=null ? nextChatMessage['userId'] : null;

                 final nextUserIsSame = nextMessageUserId == currentMessageUserId;

                 if(nextUserIsSame){
                   return MessageBubble.next(message: chatMessage['text'],
                       isMe: authenticatedUser.uid == currentMessageUserId );
                 }
                 else{
                  return MessageBubble.first(
                       userImage: chatMessage['userImage'],
                       userName: chatMessage['username'],
                       message: chatMessage['text'],
                       isMe: authenticatedUser.uid == currentMessageUserId
                   );
                 }

            });

          })
    ;
  }
}
