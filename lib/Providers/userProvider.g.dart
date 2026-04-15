// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$user_authHash() => r'd0e65c2e2020f5223e8c2fe740fbb8157d0379d7';

/// See also [user_auth].
@ProviderFor(user_auth)
final user_authProvider = AutoDisposeStreamProvider<UserDetails?>.internal(
  user_auth,
  name: r'user_authProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$user_authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef User_authRef = AutoDisposeStreamProviderRef<UserDetails?>;
String _$userNotifierHash() => r'34f1f28527999d1b69530dd7d5362613a99af675';

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeNotifierProvider<UserNotifier, UserDetails?>.internal(
      UserNotifier.new,
      name: r'userNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserNotifier = AutoDisposeNotifier<UserDetails?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
