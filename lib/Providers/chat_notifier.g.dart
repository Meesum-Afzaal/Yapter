// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatNotiferHash() => r'257514dc80aee47bb214c3a78286ba9dad467341';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ChatNotifer
    extends BuildlessAutoDisposeNotifier<List<Message>> {
  late final String chatId;

  List<Message> build(String chatId);
}

/// See also [ChatNotifer].
@ProviderFor(ChatNotifer)
const chatNotiferProvider = ChatNotiferFamily();

/// See also [ChatNotifer].
class ChatNotiferFamily extends Family<List<Message>> {
  /// See also [ChatNotifer].
  const ChatNotiferFamily();

  /// See also [ChatNotifer].
  ChatNotiferProvider call(String chatId) {
    return ChatNotiferProvider(chatId);
  }

  @override
  ChatNotiferProvider getProviderOverride(
    covariant ChatNotiferProvider provider,
  ) {
    return call(provider.chatId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatNotiferProvider';
}

/// See also [ChatNotifer].
class ChatNotiferProvider
    extends AutoDisposeNotifierProviderImpl<ChatNotifer, List<Message>> {
  /// See also [ChatNotifer].
  ChatNotiferProvider(String chatId)
    : this._internal(
        () => ChatNotifer()..chatId = chatId,
        from: chatNotiferProvider,
        name: r'chatNotiferProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chatNotiferHash,
        dependencies: ChatNotiferFamily._dependencies,
        allTransitiveDependencies: ChatNotiferFamily._allTransitiveDependencies,
        chatId: chatId,
      );

  ChatNotiferProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  List<Message> runNotifierBuild(covariant ChatNotifer notifier) {
    return notifier.build(chatId);
  }

  @override
  Override overrideWith(ChatNotifer Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatNotiferProvider._internal(
        () => create()..chatId = chatId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChatNotifer, List<Message>>
  createElement() {
    return _ChatNotiferProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatNotiferProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatNotiferRef on AutoDisposeNotifierProviderRef<List<Message>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatNotiferProviderElement
    extends AutoDisposeNotifierProviderElement<ChatNotifer, List<Message>>
    with ChatNotiferRef {
  _ChatNotiferProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatNotiferProvider).chatId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
