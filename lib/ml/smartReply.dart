import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

// -------------------
// Top-level ChatMessage class
// -------------------
class ChatMessage {
  final String text;
  final bool isLocalUser;
  final int timestamp;
  final String? userId; // for remote messages

  ChatMessage({
    required this.text,
    required this.isLocalUser,
    required this.timestamp,
    this.userId,
  });
}

// -------------------
// Smart Reply Screen
// -------------------
class SmartReplyScreen extends StatefulWidget {
  const SmartReplyScreen({super.key});

  @override
  State<SmartReplyScreen> createState() => _SmartReplyScreenState();
}

class _SmartReplyScreenState extends State<SmartReplyScreen> {

  final TextEditingController messageController = TextEditingController();

  // SmartReply instance from the plugin
  late final SmartReply smartReply;

  // Local conversation model for UI rendering
  final List<ChatMessage> chat = [];

  // Suggested replies returned by the plugin
  List<String> suggestedReplies = [];

  @override
  void initState() {
    super.initState();
    smartReply = SmartReply();
  }

  @override
  void dispose() {
    smartReply.close();
    super.dispose();
  }

  // Add message and feed SmartReply
  Future<void> addMessage(String text,
      {required bool fromLocalUser, String? remoteUserId}) async {
    if (text.trim().isEmpty) return;

    final ts = DateTime.now().millisecondsSinceEpoch;

    // Add to local chat list
    setState(() {
      chat.add(ChatMessage(
          text: text.trim(),
          isLocalUser: fromLocalUser,
          timestamp: ts,
          userId: remoteUserId));
    });

    // Add to SmartReply conversation
    if (fromLocalUser) {
      smartReply.addMessageToConversationFromLocalUser(text.trim(), ts);
    } else {
      smartReply.addMessageToConversationFromRemoteUser(
          text.trim(), ts, remoteUserId ?? 'remote_user');
    }

    // Generate suggested replies
    await generateSmartReplies();
  }

  // Generate replies using ML Kit
  Future<void> generateSmartReplies() async {
    try {
      final SmartReplySuggestionResult response =
      await smartReply.suggestReplies();

      setState(() {
        suggestedReplies = response.suggestions;
      });
    } catch (e) {
      setState(() => suggestedReplies = []);
    }
  }

  // When user taps a suggestion
  void onSelectSuggestion(String reply) {
    addMessage(reply, fromLocalUser: true);
    setState(() => suggestedReplies = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Reply')),
      body: Column(
        children: [
          // Chat list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.length,
              itemBuilder: (context, i) {
                final m = chat[i];
                return Align(
                  alignment:
                  m.isLocalUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: m.isLocalUser ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                          color: m.isLocalUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          // Suggested replies
          if (suggestedReplies.isNotEmpty)
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Wrap(
                spacing: 8,
                children: suggestedReplies.map((s) {
                  return ElevatedButton(
                    onPressed: () => onSelectSuggestion(s),
                    child: Text(s),
                  );
                }).toList(),
              ),
            ),

          // Input row
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration:
                      const InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      addMessage(messageController.text, fromLocalUser: true);
                      messageController.clear();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      addMessage('Hello from remote',
                          fromLocalUser: false, remoteUserId: 'user_2');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
