import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> _currentMessages = [];
  List<Map<String, dynamic>> _conversations = [];
  String? _currentConversationId; // Using String for SharedPreferences keys

  // LM Studio API endpoint
  final String _lmStudioUrl = 'http://127.0.0.1:1234/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationKeys = prefs.getKeys().where((key) => key.startsWith('conversation_')).toList();

    final List<Map<String, dynamic>> loadedConversations = [];
    for (String key in conversationKeys) {
      final String? conversationJson = prefs.getString(key);
      if (conversationJson != null) {
        loadedConversations.add(json.decode(conversationJson));
      }
    }

    if (!mounted) return;
    setState(() {
      _conversations = loadedConversations;
      if (_conversations.isNotEmpty && _currentConversationId == null) {
        _loadConversation(_conversations.first['id'] as String, _conversations.first);
      } else if (_currentConversationId != null) {
        final current = _conversations.firstWhereOrNull((conv) => conv['id'] == _currentConversationId);
        if (current != null) {
          _loadConversation(current['id'] as String, current);
        } else {
          _startNewChat();
        }
      } else {
        _startNewChat();
      }
    });
  }

  void _loadConversation(String id, Map<String, dynamic> conversationData) {
    if (!mounted) return;
    setState(() {
      _currentConversationId = id;
      _currentMessages = (conversationData['messages'] as List)
          .map((msg) => Map<String, String>.from(msg))
          .toList();
    });
    _scrollToBottom();
  }

  void _startNewChat() {
    if (!mounted) return;
    setState(() {
      _currentMessages = [];
      _currentConversationId = null;
    });
  }

  Future<void> _saveCurrentConversation() async {
    if (_currentMessages.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    String conversationId = _currentConversationId ?? 'conversation_${DateTime.now().millisecondsSinceEpoch}';

    final conversationData = {
      'id': conversationId,
      'title': _currentMessages.first['content']!.substring(0, (_currentMessages.first['content']!.length > 30 ? 30 : _currentMessages.first['content']!.length)),
      'messages': _currentMessages,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await prefs.setString('conversation_$conversationId', json.encode(conversationData));
    _currentConversationId = conversationId; // Ensure ID is set for new conversations
    await _loadConversations(); // Refresh the list of conversations
  }

  Future<void> _deleteConversation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('conversation_$id');
    await _loadConversations();
    if (_currentConversationId == id) {
      _startNewChat();
    }
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    if (!mounted) return;
    setState(() {
      _currentMessages.add({'role': 'user', 'content': text});
    });

    _scrollToBottom();
    await _saveCurrentConversation();

    try {
      final response = await _getLmStudioResponse();
      if (!mounted) return;
      setState(() {
        _currentMessages.add({'role': 'assistant', 'content': response});
      });
      await _saveCurrentConversation();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentMessages.add({'role': 'assistant', 'content': 'Error: $e'});
      });
      await _saveCurrentConversation();
    }

    _scrollToBottom();
  }

  Future<String> _getLmStudioResponse() async {
    final List<Map<String, String>> conversationHistory = _currentMessages.map((msg) {
      return {'role': msg['role']!, 'content': msg['content']!};
    }).toList();

    final Map<String, dynamic> requestBody = {
      "model": "local-model", // Replace with your LM Studio model name if different
      "messages": conversationHistory,
      "temperature": 0.7,
      "max_tokens": -1,
      "stream": false,
    };

    final http.Response response = await http.post(
      Uri.parse(_lmStudioUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response: ${response.statusCode} ${response.body}');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LM Studio Chatbot'),
        backgroundColor: Colors.deepPurple.shade300, // Attractive color
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30), // Changed to a simple '+' icon
            onPressed: () {
              _startNewChat();
            },
            color: Colors.white,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Flexible(
            child: _currentMessages.isEmpty
                ? _buildWelcomeScreen()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    reverse: false,
                    itemBuilder: (_, int index) {
                      final message = _currentMessages[index];
                      return _buildMessage(message['content']!, message['role']!);
                    },
                    itemCount: _currentMessages.length,
                  ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.deepPurple.shade100,
            child: Icon(
              Icons.android, // Chatbot icon
              size: 60,
              color: Colors.deepPurple.shade700,
            ),
          ),
          const SizedBox(height: 20),
          _buildMessage('Hi! I\'m a chat bot. How can I help you?', 'assistant'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300, // Attractive color
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                'Conversations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_comment),
            title: const Text('New Chat'),
            onTap: () {
              _startNewChat();
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                final title = conversation['title'] as String? ?? 'New Chat';
                final id = conversation['id'] as String;
                return ListTile(
                  title: Text(title),
                  selected: _currentConversationId == id,
                  onTap: () {
                    _loadConversation(id, conversation);
                    Navigator.of(context).pop(); // Close the drawer
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteConversation(id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0), // Added padding here
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Colors.deepPurple.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, String role) {
    final isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple.shade300 : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isUser ? const Radius.circular(16.0) : const Radius.circular(4.0),
            bottomRight: isUser ? const Radius.circular(4.0) : const Radius.circular(16.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          const Text('Please, review us', style: TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: Colors.amber,
                size: 24,
              );
            }),
          ),
        ],
      ),
    );
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
