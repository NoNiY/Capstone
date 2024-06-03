import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _sendFeedback() async {
    setState(() {
      _isSending = true;
    });

    final Email email = Email(
      body: _controller.text,
      subject: '건의사항',
      recipients: ['shuttle0116@gmail.com'], // 관리자의 이메일 주소로 변경
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('건의사항이 성공적으로 전송되었습니다.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('건의사항 전송에 실패했습니다. 다시 시도해주세요.')),
      );
    }

    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('건의사항 보내기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '건의사항을 입력하세요',
              ),
            ),
            SizedBox(height: 16.0),
            _isSending
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendFeedback,
              child: Text('전송'),
            ),
          ],
        ),
      ),
    );
  }
}
