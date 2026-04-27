import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================================
/// 1. USER MODEL
/// ================================
class TempUser {
  final String name;
  final String image;
  final bool isOnline;

  TempUser({
    required this.name,
    required this.image,
    required this.isOnline,
  });

  // needed in Riverpod (because state is immutable)
  TempUser copyWith({bool? isOnline}) {
    return TempUser(
      name: name,
      image: image,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

/// ================================
/// 2. TEMP USERS DATA (20 USERS)
/// ================================
class TempUsers {
  static List<TempUser> users = [
    TempUser(name: "John Smith", image: "https://i.pravatar.cc/150?img=1", isOnline: true),
    TempUser(name: "Michael Brown", image: "https://i.pravatar.cc/150?img=2", isOnline: false),
    TempUser(name: "Connor Williams", image: "https://i.pravatar.cc/150?img=3", isOnline: true),
    TempUser(name: "James Wilson", image: "https://i.pravatar.cc/150?img=4", isOnline: false),
    TempUser(name: "David Johnson", image: "https://i.pravatar.cc/150?img=5", isOnline: true),
    TempUser(name: "Daniel Miller", image: "https://i.pravatar.cc/150?img=6", isOnline: false),
    TempUser(name: "Ethan Davis", image: "https://i.pravatar.cc/150?img=7", isOnline: true),
    TempUser(name: "Liam Anderson", image: "https://i.pravatar.cc/150?img=8", isOnline: false),
    TempUser(name: "Noah Thomas", image: "https://i.pravatar.cc/150?img=9", isOnline: true),
    TempUser(name: "Oliver Taylor", image: "https://i.pravatar.cc/150?img=10", isOnline: false),
    TempUser(name: "William Moore", image: "https://i.pravatar.cc/150?img=11", isOnline: true),
    TempUser(name: "Benjamin Clark", image: "https://i.pravatar.cc/150?img=12", isOnline: false),
    TempUser(name: "Lucas Hall", image: "https://i.pravatar.cc/150?img=13", isOnline: true),
    TempUser(name: "Henry Allen", image: "https://i.pravatar.cc/150?img=14", isOnline: false),
    TempUser(name: "Jack Young", image: "https://i.pravatar.cc/150?img=15", isOnline: true),
    TempUser(name: "Leo King", image: "https://i.pravatar.cc/150?img=16", isOnline: false),
    TempUser(name: "Ryan Scott", image: "https://i.pravatar.cc/150?img=17", isOnline: true),
    TempUser(name: "Nathan Green", image: "https://i.pravatar.cc/150?img=18", isOnline: false),
    TempUser(name: "Adam Wright", image: "https://i.pravatar.cc/150?img=19", isOnline: true),
    TempUser(name: "Caleb Baker", image: "https://i.pravatar.cc/150?img=20", isOnline: false),
  ];
}

/// ================================
/// 3. RIVERPOD STATE NOTIFIER
/// ================================
class UserNotifier extends StateNotifier<List<TempUser>> {
  UserNotifier() : super(TempUsers.users);

  void toggleStatus(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isOnline: !state[i].isOnline)
        else
          state[i],
    ];
  }
}

/// ================================
/// 4. PROVIDER (Riverpod)
/// ================================
final userProvider =
StateNotifierProvider<UserNotifier, List<TempUser>>(
      (ref) => UserNotifier(),
);