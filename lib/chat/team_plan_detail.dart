class PlanDetailsScreen extends StatefulWidget {
  final Plan plan;
  final int index;

  const PlanDetailsScreen({Key? key, required this.plan, required this.index}) : super(key: key);

  @override
  _PlanDetailsScreenState createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  List<String> _participants = [];

  @override
  void initState() {
    super.initState();
    _participants = List.from(widget.plan.participants);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계획 상세 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '계획 내용: ${widget.plan.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '시작일: ${DateFormat('yyyy-MM-dd').format(widget.plan.startDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '종료일: ${DateFormat('yyyy-MM-dd').format(widget.plan.endDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '참여자: ${_participants.join(', ')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addParticipant();
              },
              child: const Text('참여자 추가'),
            ),
            ElevatedButton(
              onPressed: () {
                _deletePlan(context);
              },
              child: const Text('채팅방'),
            ),
          ],
        ),
      ),
    );
  }

  void _addParticipant() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: const Text('참여자 추가'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _participants.add(_controller.text);
                  _controller.clear(); // 입력 필드 비우기
                });
                Navigator.of(context).pop();
              },
              child: const Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('채팅방'),
          content: const Text('채팅방으로 이동하겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return const ChatScreen();
                    }
                ));
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
