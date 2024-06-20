import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first(
      {super.key,
      required this.userImage,
      required this.userName,
      required this.message,
      required this.isMe})
      : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        userName = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? userName;
  final String message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            right: isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage!),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence)
                    const SizedBox(
                      height: 18,
                    ),
                  if (userName != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Text(
                        userName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color:  Color.fromARGB(255, 10, 20, 148),
                        ),
                      ),
                    ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(16),
                        topRight: isMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color:Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
