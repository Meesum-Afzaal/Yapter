<h1 align="center">Yapter</h1>

<p align="center">
  <strong>A real-time messaging application built with Flutter, Dart, and Firebase.</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart_3.10%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart 3.10+"></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/Riverpod-00B8D4?style=for-the-badge" alt="Riverpod"></a>
  <img src="https://img.shields.io/badge/Status-In%20Development-orange?style=for-the-badge" alt="Status: In Development">
</p>

<p align="center">
  <a href="#about">About</a> &nbsp;·&nbsp;
  <a href="#key-features">Features</a> &nbsp;·&nbsp;
  <a href="#technology-stack">Stack</a> &nbsp;·&nbsp;
  <a href="#technical-highlights">Highlights</a> &nbsp;·&nbsp;
  <a href="#security--message-protection">Security</a> &nbsp;·&nbsp;
  <a href="#backend--data-management">Backend</a> &nbsp;·&nbsp;
  <a href="#future-improvements">Roadmap</a> &nbsp;·&nbsp;
  <a href="#feedback--contributions">Feedback</a>
</p>

---

## About

Yapter is a WhatsApp-inspired, cross-platform messaging application focused on real-time one-to-one communication. It combines phone number authentication, message encryption and decryption, live user presence, and a modern chat interface.

The app is written in Flutter and Dart. Firebase provides authentication and real-time data synchronization, while Riverpod manages application state and dependencies on the client.

> [!NOTE]
> Yapter is an ongoing development project. This document describes what is currently implemented. Potential enhancements are listed separately under [Future Improvements](#future-improvements).

## Key Features

<table width="100%">
  <tr>
    <td width="50%" valign="top" align="left">
      <b>Messaging</b><br>
      &bull; Real-time one-to-one messaging<br>
      &bull; Real-time data synchronization<br>
      &bull; Message pagination (latest 30 messages)
    </td>
    <td width="50%" valign="top" align="left">
      <b>Presence &amp; Status</b><br>
      &bull; Online/offline user presence<br>
      &bull; Real-time typing indicators<br>
      &bull; Message read receipts
    </td>
  </tr>
  <tr>
    <td width="50%" valign="top" align="left">
      <b>Authentication &amp; Accounts</b><br>
      &bull; Firebase-based authentication<br>
      &bull; Phone number and OTP verification<br>
      &bull; User profiles and account management
    </td>
    <td width="50%" valign="top" align="left">
      <b>Security &amp; Experience</b><br>
      &bull; Message encryption and decryption<br>
      &bull; WhatsApp-inspired user interface<br>
      &bull; Reactive state management with Riverpod
    </td>
  </tr>
</table>

## Technology Stack

| Technology | Package | Role |
| --- | --- | --- |
| **Flutter** | | Cross-platform mobile application framework used to build the user interface and application logic |
| **Dart** | | Primary programming language of the project |
| **Firebase Core** | [`firebase_core`](https://pub.dev/packages/firebase_core) | Firebase initialization and configuration |
| **Firebase Authentication** | [`firebase_auth`](https://pub.dev/packages/firebase_auth) | User authentication and account management |
| **Cloud Firestore** | [`cloud_firestore`](https://pub.dev/packages/cloud_firestore) | Real-time database functionality and message data management |
| **Firebase Realtime Database** | [`firebase_database`](https://pub.dev/packages/firebase_database) | Real-time data synchronization alongside Cloud Firestore |
| **Riverpod** | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | State management and dependency management |
| **Cryptography** | [`cryptography`](https://pub.dev/packages/cryptography) | Cryptographic operations for message encryption and decryption |
| **Secure storage** | [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) | Secure on-device storage for sensitive values |
| **Hive CE** | [`hive_ce`](https://pub.dev/packages/hive_ce), [`hive_ce_flutter`](https://pub.dev/packages/hive_ce_flutter) | Local on-device data persistence and its Flutter integration |
| **Pinput** | [`pinput`](https://pub.dev/packages/pinput) | OTP input interface for phone number verification |
| **IsoCode** | [`phone_numbers_parser`](https://pub.dev/packages/phone_numbers_parser) | Phone number parsing and country code handling, including Pakistan (+92) |
| **Country code picker** | [`country_code_picker`](https://pub.dev/packages/country_code_picker) | Country code selection interface |
| **International phone input** | [`intl_phone_number_input`](https://pub.dev/packages/intl_phone_number_input) | International phone number input field |
| **Flutter SpinKit** | [`flutter_spinkit`](https://pub.dev/packages/flutter_spinkit) | Loading indicators |

### Riverpod Code Generation

Riverpod's code-generation workflow is separate from the `flutter_riverpod` runtime package listed above.

| Package | Type | Role |
| --- | --- | --- |
| [`riverpod_annotation`](https://pub.dev/packages/riverpod_annotation) | Dependency | Annotations used with the Riverpod generator |
| [`riverpod_generator`](https://pub.dev/packages/riverpod_generator) | Development dependency | Generates provider code from annotations |
| [`build_runner`](https://pub.dev/packages/build_runner) | Development dependency | Runs code generation at build time |

## Technical Highlights

| Area | Description |
| --- | --- |
| **Real-time messaging** | Conversations are synchronized in real time, so new messages appear for participants as they are sent without manual refreshing. |
| **Encryption and decryption** | Message content passes through encryption and decryption routines built on the Cryptography package. See [Security & Message Protection](#security--message-protection) for the scope of this functionality. |
| **Authentication** | Users sign in with their phone number and verify it with a one-time password through Firebase Authentication. Pinput provides the OTP entry interface, and phone number and country code handling covers Pakistan (+92). |
| **Presence tracking** | Online/offline status is tracked so a user's availability can be reflected to the people they are chatting with. |
| **Typing indicators** | Typing activity is surfaced in real time within a conversation. |
| **Read receipts** | Read receipts allow the sender to see when a message has been read. |
| **Pagination** | Message loading is paginated, retrieving the latest 30 messages rather than an entire conversation history at once. |
| **State management** | Riverpod drives reactive state and dependency management, keeping the interface in step with incoming real-time data. |

## Security & Message Protection

Yapter uses the [Cryptography](https://pub.dev/packages/cryptography) package to implement message encryption and decryption. Security is an important consideration in the project, and message content is processed through a cryptographic layer within the application. User identity is handled separately by Firebase Authentication through phone number and OTP verification.

The current implementation is still evolving. Further security enhancements, testing, and architectural improvements are part of ongoing development.

> [!NOTE]
> Yapter does not claim WhatsApp-level, industry-leading, or independently validated encryption standards. The cryptographic implementation reflects the project's current stage of development and is best evaluated in that context.

Developers are welcome to review the cryptographic implementation and share constructive feedback. See [Feedback & Contributions](#feedback--contributions).

## Backend & Data Management

| Layer | Service | Responsibility |
| --- | --- | --- |
| Backend | **Firebase Authentication** | User sign-in through phone number and OTP verification, along with account management |
| Backend | **Cloud Firestore** | Real-time database storing message data and keeping it synchronized between participants |
| Backend | **Firebase Realtime Database** | Additional real-time data layer alongside Cloud Firestore |
| Device | **Hive CE** | Local data persistence |
| Device | **flutter_secure_storage** | Secure storage of sensitive values |

## Future Improvements

> [!NOTE]
> The following are potential enhancements. They are **not** part of the current implementation and do not represent committed plans.

- End-to-end encryption with a formally designed key exchange model
- An independent review of the cryptographic implementation
- Group conversations
- Push notifications
- Message search
- Automated test coverage

## Feedback & Contributions

> Yapter is an ongoing development project, and feedback is always welcome. If you encounter any bugs, technical issues, implementation mistakes, or areas that could be improved, feel free to open an issue or share your constructive criticism. Suggestions and contributions are appreciated.

Developers are encouraged to:

- Review the code and architecture
- Report bugs through [GitHub Issues](https://github.com/Meesum-Afzaal/Yapter/issues)
- Point out implementation mistakes or questionable decisions
- Suggest improvements or share constructive criticism
- Contribute fixes and enhancements

When reporting a bug, the expected behavior, the actual behavior, and the steps to reproduce it make it much easier to investigate.

---

<sub>Yapter is an independent project. It is not affiliated with, endorsed by, or sponsored by Meta, WhatsApp, Google, or Firebase. WhatsApp, Firebase, Flutter, Dart, and other product names are trademarks of their respective owners and are referenced only to describe the project's design inspiration and the technologies it uses.</sub>
