import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 intl 임포트
import '../../../core/base_screen.dart';
import '../../chatbot/viewmodel/chat_viewmodel.dart';
import '../../chatbot/model/chat_message.dart'; // ChatMessage 모델 임포트

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends BaseScreen<ChatHistoryScreen> {
  // ChatViewModel은 이미 main.dart에서 초기화되고 메시지를 로드하므로,
  // 여기서는 별도의 Future를 가질 필요가 없습니다.
  // 대신 Consumer 또는 context.watch를 사용하여 ViewModel의 메시지 목록을 직접 관찰합니다.

  @override
  void initState() {
    super.initState();
    // ChatViewModel의 메시지 목록은 이미 SharedPreferences에서 로드되어 있으므로
    // 별도의 비동기 로드 메서드를 호출할 필요 없음.
    // 다만, ChatViewModel의 초기화 시점과 이 화면의 빌드 시점 차이로 인해
    // 데이터가 아직 없을 수 있으므로, ChatViewModel이 로딩 중임을 나타내는 상태가 필요하다면 추가.
    // 여기서는 ViewModel이 이미 로드되었다고 가정하고 바로 사용.
  }

  @override
  Widget buildBody(BuildContext context) {
    // ChatViewModel의 변화를 감지하여 UI를 업데이트합니다.
    final chatViewModel = context.watch<ChatViewModel>();

    // 대화 기록이 없을 때 메시지
    if (chatViewModel.messages.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('챗봇 대화 기록'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            '대화 기록이 없습니다. 챗봇과 대화를 시작해보세요!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('챗봇 대화 기록'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('기록 삭제'),
                    content: const Text('모든 챗봇 대화 기록을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('삭제'),
                      ),
                    ],
                  );
                },
              );
              if (confirmed == true) {
                await chatViewModel.clearChatHistory();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('대화 기록이 삭제되었습니다.')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: false, // 최신 메시지가 아래에 표시되도록
        itemCount: chatViewModel.messages.length,
        itemBuilder: (context, index) {
          final message = chatViewModel.messages[index];
          final bool isUserMessage = message.sender == MessageSender.user; // ✅ sender 필드 사용

          return Align(
            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: isUserMessage ? Theme.of(context).primaryColor.withOpacity(0.8) : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isUserMessage ? const Radius.circular(12) : const Radius.circular(4),
                  bottomRight: isUserMessage ? const Radius.circular(4) : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(message.timestamp), // ✅ timestamp 필드 사용
                    style: TextStyle(
                      color: isUserMessage ? Colors.white70 : Colors.black54,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
