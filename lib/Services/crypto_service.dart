import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoService {

  final X25519 _x25519 = X25519();

  final AesGcm _aes = AesGcm.with256bits();

  final Hkdf _hkdf = Hkdf(
    hmac: Hmac.sha256(),
    outputLength: 32,
  );

  final FlutterSecureStorage _storage =
  FlutterSecureStorage();
  Future<void> initializeKeys() async {
    final existingPrivateKey = await _storage.read(
      key: 'yapter_x25519_key',
    );
    if (existingPrivateKey != null) {
      return;
    }
    await generateKeys();
  }
  Future<String> generateKeys() async {
    final keyPair = await _x25519.newKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    final privateKey = base64Encode(privateKeyBytes);
    _storage.write(
        key: "yapter_x25519_key",
        value: privateKey
    );
    final publicKeyBytes = await keyPair.extractPublicKey();
    final publicKey = base64Encode(publicKeyBytes.bytes);
    return publicKey;
  }
  Future<SecretKey> getAesKey(String friendPublicKey)async{
    final myKeyPair=await getMyKeyPair();
    final friendPublicKeyBytes=base64Decode(friendPublicKey);
    final remotePubKey = SimplePublicKey(
      friendPublicKeyBytes,
      type: KeyPairType.x25519,
    );
    final sharedSecret=await _x25519.sharedSecretKey(
      keyPair:myKeyPair,
      remotePublicKey:remotePubKey,
    );
    final sharedBytes=await sharedSecret.extractBytes();
    final aesKey=await _hkdf.deriveKey(
      secretKey:SecretKey(sharedBytes)
    );
    return aesKey;


  }

  Future<SimpleKeyPair> getMyKeyPair() async {
    final privateKeyBase64 = await _storage.read(
      key: 'yapter_x25519_key',
    );

    if (privateKeyBase64 == null) {
      throw Exception('Private key not found');
    }

    final privateKeyBytes = base64Decode(privateKeyBase64);

    return await _x25519.newKeyPairFromSeed(
      privateKeyBytes,
    );
  }

  Future<SecretBox> encryptMessage(String message, SecretKey aesKey) async {
    final messageBytes = utf8.encode(message);
    final nonce = _aes.newNonce();
    final secretBox = await _aes.encrypt(
        messageBytes,
        secretKey: aesKey,
        nonce: nonce
    );
    return secretBox;
  }

  Future<String> decryptMessage(SecretBox secretBox,
      SecretKey aesKey,) async {
    final decryptedBytes = await _aes.decrypt(
        secretBox,
        secretKey: aesKey
    );
    final message = utf8.decode(decryptedBytes);
    return message;
  }

}
