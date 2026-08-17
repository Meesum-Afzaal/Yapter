import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/message.dart';
import 'package:yapter/Providers/chat_notifier.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:yapter/Services/typing_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String friendName;
  final String friendUid;

  const ChatScreen({
    super.key,
    required this.friendName,
    required this.friendUid,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final typingService = TypingService();

  Timer? debounce;

  String? chatId;
  String? sender;

  bool _isInitialLoad = true;
  bool _isLoadingMore = false;
  bool _isApproaching = false;

  @override
  void initState() {
    super.initState();

    loadChatId();

    _scrollController.addListener(_onScroll);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isInitialLoad = false;
        });
      }
    });
  }

  @override
  void dispose() {
    debounce?.cancel();

    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void loadChatId() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final List<String> userIds = [currentUserId, widget.friendUid];

    userIds.sort();

    final generatedChatId = userIds.join('_');

    ref
        .read(firestoreServiceProvider)
        .markMessagesSeen(generatedChatId, currentUserId);

    setState(() {
      chatId = generatedChatId;
      sender = currentUserId;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients || chatId == null) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    final approachThreshold = maxScroll - 200;
    final loadThreshold = maxScroll - 50;

    final notifier = ref.read(chatNotiferProvider(chatId!).notifier);

    if (!notifier.hasMore) {
      if (_isApproaching) {
        setState(() {
          _isApproaching = false;
        });
      }

      return;
    }

    if (_isLoadingMore) {
      return;
    }

    if (currentScroll >= loadThreshold) {
      _triggerLoadMore(notifier);
    } else if (currentScroll >= approachThreshold) {
      if (!_isApproaching) {
        setState(() {
          _isApproaching = true;
        });
      }
    } else {
      if (_isApproaching) {
        setState(() {
          _isApproaching = false;
        });
      }
    }
  }

  Future<void> _triggerLoadMore(dynamic notifier) async {
    setState(() {
      _isLoadingMore = true;
      _isApproaching = false;
    });

    try {
      await notifier.loadMoreMessages(chatId!);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  String formatTime(Message msg) {
    final dt = msg.createdAt;

    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);

    final min = dt.minute.toString().padLeft(2, '0');

    final amPm = dt.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$min $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final messages = ref.watch(chatNotiferProvider(chatId!));

    final backgroundColor = theme.scaffoldBackgroundColor;

    final surfaceColor = theme.colorScheme.surface;

    final textColor = theme.colorScheme.onSurface;

    final secondaryTextColor = theme.colorScheme.onSurface.withOpacity(0.6);

    final disabledTextColor = theme.colorScheme.onSurface.withOpacity(0.4);

    const accentColor = Colors.blue;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor,
        elevation: 0,
        titleSpacing: 4,

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: NeumorphicCircle(
              size: 40,
              backgroundColor: surfaceColor,
              child: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
            ),
          ),
        ),

        title: Row(
          children: [
            NeumorphicCircle(
              size: 40,
              backgroundColor: surfaceColor,
              child: const Icon(Icons.person, color: accentColor, size: 22),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  "Online",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: NeumorphicCircle(
                size: 40,
                backgroundColor: surfaceColor,
                child: Icon(Icons.more_vert, color: textColor, size: 20),
              ),
            ),
          ),

          const SizedBox(width: 4),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),

        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? (_isInitialLoad
                        ? Center(
                            child: NeumorphicCircle(
                              size: 50,
                              backgroundColor: surfaceColor,
                              child: SpinKitDualRing(
                                color: secondaryTextColor,
                                size: 20.0,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Say Hi to your friend",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                          ))
                  : ListView.builder(
                      controller: _scrollController,
                      clipBehavior: Clip.none,
                      reverse: true,

                      itemCount: messages.length + 1,

                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          final notifier = ref.read(
                            chatNotiferProvider(chatId!).notifier,
                          );

                          final hasMore = notifier.hasMore;

                          return AnimatedSize(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.bottomCenter,

                            child:
                                ((_isApproaching || _isLoadingMore) && hasMore)
                                ? Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),

                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),

                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              ),
                                            );
                                          },

                                      child: _isLoadingMore
                                          ? NeumorphicCircle(
                                              key: const ValueKey('loading'),
                                              size: 40,
                                              backgroundColor: surfaceColor,
                                              child: CircularProgressIndicator(
                                                color: accentColor,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : NeumorphicCircle(
                                              key: const ValueKey(
                                                'approaching',
                                              ),
                                              size: 40,
                                              backgroundColor: surfaceColor,
                                              child: Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                size: 24,
                                                color: disabledTextColor,
                                              ),
                                            ),
                                    ),
                                  )
                                : const SizedBox(
                                    width: double.infinity,
                                    height: 0,
                                  ),
                          );
                        }

                        final msg = messages[index];

                        final isMe = msg.senderId == sender;

                        Widget messageWidget = Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 6.0,
                            right: 6.0,
                          ),

                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,

                            children: [
                              if (isMe) const Spacer(),

                              Flexible(
                                child: NeumorphicContainer(
                                  backgroundColor: surfaceColor,
                                  isPressed: isMe,

                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.78,
                                    ),

                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),

                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,

                                      children: [
                                        Text(
                                          msg.text,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(color: textColor),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            bottom: 1,
                                          ),

                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,

                                            children: [
                                              Text(
                                                formatTime(msg),
                                                style: theme
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      fontSize: 10,
                                                      color: secondaryTextColor,
                                                    ),
                                              ),

                                              if (isMe) ...[
                                                const SizedBox(width: 4),

                                                Icon(
                                                  Icons.done_all,
                                                  size: 14,

                                                  color: msg.seen
                                                      ? accentColor
                                                      : disabledTextColor,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              if (!isMe) const Spacer(),
                            ],
                          ),
                        );

                        if (index == 0 && !_isInitialLoad) {
                          return TweenAnimationBuilder<double>(
                            key: ValueKey(msg.messageId),

                            tween: Tween<double>(begin: 0.0, end: 1.0),

                            duration: const Duration(milliseconds: 300),

                            curve: Curves.easeOutCubic,

                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(
                                  isMe ? (1 - value) * 15 : -(1 - value) * 15,
                                  (1 - value) * 10,
                                ),

                                child: Opacity(opacity: value, child: child),
                              );
                            },

                            child: messageWidget,
                          );
                        }

                        return messageWidget;
                      },
                    ),
            ),

            StreamBuilder<DatabaseEvent>(
              stream: typingService.getTypingStatus(chatId!, widget.friendUid),

              builder: (context, asyncSnapshot) {
                final isTyping = asyncSnapshot.data?.snapshot.value == true;

                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),

                  curve: Curves.easeOutCubic,

                  alignment: Alignment.bottomLeft,

                  child: isTyping
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 6.0,
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Flexible(
                                child: NeumorphicContainer(
                                  backgroundColor: surfaceColor,

                                  isPressed: false,

                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 8,
                                    ),

                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.75,
                                    ),

                                    child: SpinKitThreeBounce(
                                      color: secondaryTextColor,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),
                            ],
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                );
              },
            ),

            const SizedBox(height: 10.0),

            AnimatedBuilder(
              animation: Listenable.merge([_focusNode, _controller]),

              builder: (context, child) {
                final isInputActive =
                    _focusNode.hasFocus || _controller.text.isNotEmpty;

                final canSend = _controller.text.trim().isNotEmpty;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Expanded(
                      child: NeumorphicContainer(
                        width: 50,
                        backgroundColor: surfaceColor,
                        isPressed: isInputActive,
                        borderRadius: BorderRadius.circular(50),

                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                            maxHeight: 120,
                          ),

                          child: TextFormField(
                            controller: _controller,
                            focusNode: _focusNode,

                            maxLines: null,

                            keyboardType: TextInputType.multiline,

                            textCapitalization: TextCapitalization.sentences,

                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: textColor,
                            ),

                            decoration: InputDecoration(
                              hintText: "Type a message...",

                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: secondaryTextColor,
                              ),

                              filled: true,

                              fillColor: Colors.transparent,

                              border: InputBorder.none,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),

                            onChanged: (value) {
                              debounce?.cancel();

                              if (value.trim().isNotEmpty) {
                                typingService.settyping(chatId!, sender!, true);

                                debounce = Timer(
                                  const Duration(seconds: 3),
                                  () {
                                    typingService.settyping(
                                      chatId!,
                                      sender!,
                                      false,
                                    );
                                  },
                                );
                              } else {
                                typingService.settyping(
                                  chatId!,
                                  sender!,
                                  false,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    NeumorphicContainer(
                      height: 50,
                      width: 50,

                      backgroundColor: surfaceColor,

                      borderRadius: BorderRadius.circular(50),

                      isPressed: !canSend,

                      child: IconButton(
                        onPressed: canSend
                            ? () async {
                                final text = _controller.text.trim();

                                if (text.isNotEmpty) {
                                  _controller.clear();

                                  typingService.settyping(
                                    chatId!,
                                    sender!,
                                    false,
                                  );

                                  debounce?.cancel();

                                  await ref
                                      .read(firestoreServiceProvider)
                                      .sendMessage(
                                        sender!,
                                        widget.friendUid,
                                        text,
                                      );
                                }
                              }
                            : null,

                        icon: Icon(
                          Icons.send,

                          color: canSend ? accentColor : disabledTextColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
