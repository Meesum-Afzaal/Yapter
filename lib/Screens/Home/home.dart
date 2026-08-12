import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:yapter/Screens/ChatScreen/chat_screen.dart';
import 'package:yapter/Services/auth.dart';
import 'package:yapter/temp/tempUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yapter/Theme/app_theme.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<AnimatedListState> _listKey =
  GlobalKey<AnimatedListState>();

  final Auth auth = Auth();

  List<UserDetails>? friends;
  bool loading = true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() => setState(() {}));
    _searchFocusNode.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFriends();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void loadFriends() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final response = await ref
        .read(firestoreServiceProvider)
        .getFriends(currentUserId);

    if (mounted) {
      setState(() {
        friends = response;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);

    // Gets the background from the currently active AppTheme.
    final baseColor = AppTheme.background(context);

    // Gets Flutter's current theme colors.
    final textColor = Theme.of(context).colorScheme.onSurface;

    final secondaryTextColor =
    Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: baseColor,

      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: baseColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Yapter",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: AnimatedSwitcher(duration: Duration(milliseconds: 300),child:
      loading
          ? Center(
        child: NeumorphicCircle(
          key: const ValueKey("loading"),
          backgroundColor: baseColor,
          size: 60,
          child: CircularProgressIndicator(
            color: secondaryTextColor,
          ),
        ),
      )
          : Column(
        key: const ValueKey("loaded"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20.0,
              10.0,
              20.0,
              10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: NeumorphicContainer(
                    backgroundColor: baseColor,
                    isPressed: _searchFocusNode.hasFocus ||
                        _searchController.text.isNotEmpty,
                    borderRadius: BorderRadius.circular(40),
                    child: Center(
                      child: TextFormField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: TextStyle(
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          hintText: "Search Friends",
                          hintStyle: TextStyle(
                            color: secondaryTextColor,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                NeumorphicContainer(
                  backgroundColor: baseColor,
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              25.0,
              10.0,
              25.0,
              10.0,
            ),
            child: Text(
              "Messages",
              style: TextStyle(
                color: textColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          friends!.isEmpty
              ? Center(
            child: Text(
              "No friends",
              style: TextStyle(
                color: textColor,
              ),
            ),
          )
              : Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: friends!.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: NeumorphicListItem(
                      index: index,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(
                                    friendUid:
                                    friends![index].uid!,
                                    friendName:
                                    friends![index].firstName!,
                                  ),
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          leading: NeumorphicCircle(
                            size: 55,
                            backgroundColor: baseColor,
                            child: Icon(
                              Icons.person,
                              color: secondaryTextColor,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            friends![index].firstName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Hello, how are you?",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13.0,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "12:00",
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Icon(
                                Icons.done_all,
                                size: 18,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      )
    );
  }
}

class NeumorphicListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const NeumorphicListItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<NeumorphicListItem> createState() =>
      _NeumorphicListItemState();
}

class _NeumorphicListItemState extends State<NeumorphicListItem> {
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(milliseconds: 100 * widget.index),
          () {
        if (mounted) {
          setState(() => _isPopped = true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      backgroundColor: AppTheme.background(context),
      isPressed: !_isPopped,
      borderRadius: BorderRadius.circular(16),
      child: widget.child,
    );
  }
}