import 'package:flutter/material.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/message.dart';

class ChatScreen extends StatefulWidget {
  final String FriendName;
  const ChatScreen({super.key, required this.FriendName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  String? message;

  final lightBlueHighlight = const Color(0xFF45A5FF);
  final baseVibrantBlue = const Color(0xFF0A84FF);
  final darkBlueShadow = const Color(0xFF005AC3);

  final List<Message> dummyMessages = [
    Message(
      messageId: "1",
      senderId: "me",
      receiverId: "friend",
      text: "Hey! 👋",
      createdAt: DateTime(2026, 7, 19, 9, 12),
    ),
    Message(
      messageId: "2",
      senderId: "friend",
      receiverId: "me",
      text: "Good morning! Hope you're doing well today.",
      createdAt: DateTime(2026, 7, 19, 9, 13),
    ),
    Message(
      messageId: "3",
      senderId: "me",
      receiverId: "friend",
      text: "I'm currently working on the chat screen for Yapter. I'm trying to make the UI feel smooth and modern, similar to apps like WhatsApp and Telegram while still keeping my own design language.",
      createdAt: DateTime(2026, 7, 19, 9, 18),
    ),
    Message(
      messageId: "4",
      senderId: "friend",
      receiverId: "me",
      text: "That sounds awesome! Building a polished chat interface takes time because there are so many small details like message spacing, animations, typing indicators, timestamps, and scrolling behavior.",
      createdAt: DateTime(2026, 7, 19, 9, 20),
    ),
    Message(
      messageId: "5",
      senderId: "me",
      receiverId: "friend",
      text: "Exactly! Even simple things like making long messages wrap nicely or aligning timestamps correctly can make a huge difference in the final user experience.",
      createdAt: DateTime(2026, 7, 19, 9, 25),
    ),
    Message(
      messageId: "6",
      senderId: "friend",
      receiverId: "me",
      text: "True 😂",
      createdAt: DateTime(2026, 7, 19, 9, 27),
    ),
    Message(
      messageId: "7",
      senderId: "me",
      receiverId: "friend",
      text: "I'm also experimenting with custom message bubbles, rounded corners, shadows, and subtle animations whenever a new message arrives.",
      createdAt: DateTime(2026, 7, 19, 10, 5),
    ),
    Message(
      messageId: "8",
      senderId: "friend",
      receiverId: "me",
      text: "That'll definitely make the app feel premium.",
      createdAt: DateTime(2026, 7, 19, 10, 8),
    ),
    Message(
      messageId: "9",
      senderId: "me",
      receiverId: "friend",
      text: "By the way, I'm planning to add emoji support, voice notes, image sharing, and reactions in the next few weeks after finishing the basic messaging functionality.",
      createdAt: DateTime(2026, 7, 19, 11, 15),
    ),
    Message(
      messageId: "10",
      senderId: "friend",
      receiverId: "me",
      text: "That's a solid roadmap. Finish the core features first and then gradually add the advanced ones instead of trying to build everything at once.",
      createdAt: DateTime(2026, 7, 19, 11, 18),
    ),
    Message(
      messageId: "11",
      senderId: "friend",
      receiverId: "me",
      text: "Also don't forget about loading states, error handling, offline support, and retry mechanisms. Users really appreciate apps that continue working even when the internet connection isn't perfect.",
      createdAt: DateTime(2026, 7, 19, 11, 22),
    ),
    Message(
      messageId: "12",
      senderId: "me",
      receiverId: "friend",
      text: "That's actually a really good point. I'll probably use Riverpod together with Firestore streams so the UI automatically updates whenever new messages arrive.",
      createdAt: DateTime(2026, 7, 19, 11, 30),
    ),
    Message(
      messageId: "13",
      senderId: "me",
      receiverId: "friend",
      text: "Lunch?",
      createdAt: DateTime(2026, 7, 19, 13, 2),
    ),
    Message(
      messageId: "14",
      senderId: "friend",
      receiverId: "me",
      text: "Sure! Let's grab something around 1:30 and then continue working afterwards.",
      createdAt: DateTime(2026, 7, 19, 13, 4),
    ),
    Message(
      messageId: "15",
      senderId: "me",
      receiverId: "friend",
      text: "Perfect 👍",
      createdAt: DateTime(2026, 7, 19, 13, 5),
    ),
    Message(
      messageId: "16",
      senderId: "friend",
      receiverId: "me",
      text: "I'm already outside the building.",
      createdAt: DateTime(2026, 7, 19, 13, 28),
    ),
    Message(
      messageId: "17",
      senderId: "me",
      receiverId: "friend",
      text: "Coming in five minutes. I just need to finish testing this message bubble because the alignment breaks whenever the text becomes really long and spans multiple lines across the available width.",
      createdAt: DateTime(2026, 7, 19, 13, 29),
    ),
    Message(
      messageId: "18",
      senderId: "friend",
      receiverId: "me",
      text: "No worries. Take your time. It's better to polish the UI now than to fix dozens of small layout bugs later.",
      createdAt: DateTime(2026, 7, 19, 15, 45),
    ),
    Message(
      messageId: "19",
      senderId: "me",
      receiverId: "friend",
      text: "Thanks! After this I'll probably start implementing typing indicators, read receipts, and online status. Those features should make the chat experience feel much more interactive and alive.",
      createdAt: DateTime(2026, 7, 19, 17, 10),
    ),
    Message(
      messageId: "20",
      senderId: "friend",
      receiverId: "me",
      text: "Looking forward to seeing the finished version. From everything you've described so far, Yapter is shaping up to be a really polished chat application. Keep it up! 🚀",
      createdAt: DateTime(2026, 7, 19, 17, 12),
    ),
  ];

  @override
  void initState() {
    _focusNode.addListener(() => setState(() {}));
    _controller.addListener(() => setState(() {}));
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              widget.FriendName,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              "Online",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: dummyMessages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: dummyMessages[index].senderId == 'me'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (dummyMessages[index].senderId == 'me')
                                const Spacer(),
                              Expanded(
                                child: NeumorphicContainer(
                                  backgroundColor: theme.colorScheme.surface,
                                  isPressed: dummyMessages[index].senderId == 'me',
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      dummyMessages[index].text,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                              if (dummyMessages[index].senderId != 'me')
                                const Spacer(),
                            ],
                          ));
                    })),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: NeumorphicContainer(
                    height: 50,
                    width: 50,
                    backgroundColor: theme.colorScheme.surface,
                    isPressed: _focusNode.hasFocus || _controller.text.isNotEmpty,
                    borderRadius: BorderRadius.circular(50),
                    child: TextFormField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: theme.textTheme.bodyMedium,
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none),
                      onChanged: (value) {
                        message = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                NeumorphicContainer(
                  height: 50,
                  width: 50,
                  backgroundColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(50),
                  child: IconButton(
                      onPressed: () {
                        if (message != null) {
                          setState(() {
                            dummyMessages.insert(0,Message(
                                messageId: "122",
                                senderId: "me",
                                receiverId: "friend",
                                text: message!,
                                createdAt: DateTime.now()));
                            _controller.text = '';
                            message = null;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                )
              ],
            ),
            const SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }
}