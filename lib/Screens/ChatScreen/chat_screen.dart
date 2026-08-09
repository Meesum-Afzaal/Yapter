import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yapter/Providers/chat_notifier.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String friendName;
  final String friendUid;
  const ChatScreen({super.key, required this.friendName,required this.friendUid});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  String? message;

  final lightBlueHighlight = const Color(0xFF45A5FF);
  final baseVibrantBlue = const Color(0xFF0A84FF);
  final darkBlueShadow = const Color(0xFF005AC3);


  String? chatId;
  String? sender;

  @override
  void initState() {
    _focusNode.addListener(() => setState(() {}));
    _controller.addListener(() => setState(() {}));
    loadChatId();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
  void loadChatId(){
    final currentUserId=FirebaseAuth.instance.currentUser!.uid;
    List<String> userIds = [currentUserId, widget.friendUid];
    userIds.sort();
    final _chatId = userIds.join('_');
    setState(() {
      setState(() {
        chatId=_chatId;
        sender=currentUserId;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Messages=ref.watch(chatNotiferProvider(chatId!));


    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              widget.friendName,
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
        child:Column(
          children: [
            Expanded(
                child: Messages.isEmpty ? Center(child: Text("Say Hi to your friend"),): ListView.builder(
                    reverse: true,
                    itemCount: Messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: Messages[index].senderId == sender
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (Messages[index].senderId == sender)
                                const Spacer(),
                              Expanded(
                                child: NeumorphicContainer(
                                  backgroundColor: theme.colorScheme.surface,
                                  isPressed: Messages[index].senderId == sender,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      Messages[index].text,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                              if (Messages[index].senderId != sender)
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
                      onPressed: () async {
                        if (message != null) {
                          await ref.read(firestoreServiceProvider).sendMessage(sender!, widget.friendUid, message!);
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