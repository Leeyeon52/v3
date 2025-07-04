import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 intl 패키지 임포트
import '../model/chat_message.dart'; // ChatMessage 모델 임포트
import '../viewmodel/chat_viewmodel.dart'; // ChatViewModel 임포트

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 초기 메시지 추가 (예: 챗봇 환영 메시지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatViewModel>(context, listen: false).addInitialMessage();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return; // 빈 메시지는 전송하지 않음
    _textController.clear();
    Provider.of<ChatViewModel>(context, listen: false).sendMessage(text);
    _scrollToBottom();
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
        title: const Text('챗봇과 대화하기'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, chatViewModel, child) {
                _scrollToBottom(); // 메시지 목록이 업데이트될 때마다 스크롤
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: chatViewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatViewModel.messages[index];
                    return _buildMessage(message);
                  },
                );
              },
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

  Widget _buildMessage(ChatMessage message) {
    final isUserMessage = message.isUser; // message.sender 대신 message.isUser 사용
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUserMessage) // 챗봇 메시지일 때만 아바타와 이름 표시
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text('봇', style: TextStyle(color: Colors.white)),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUserMessage)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'MediTooth 봇',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Material(
                  color: isUserMessage ? Theme.of(context).primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0),
                  child: Text(
                    DateFormat('HH:mm').format(DateTime.now()), // message.timestamp 대신 DateTime.now() 사용 (필요시 모델에 timestamp 추가)
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUserMessage)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(hintText: '메시지를 입력하세요'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}