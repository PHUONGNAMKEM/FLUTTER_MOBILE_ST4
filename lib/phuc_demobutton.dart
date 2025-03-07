import 'package:flutter/material.dart';

void main() => runApp(const ButtonDemoScreen());

// class ButtonExampleApp extends StatelessWidget {
//   const ButtonExampleApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Button Demo'),
//         ),
//         body: Center(
//           child: OverflowBar(
//             alignment: MainAxisAlignment.center,
//             children: <Widget>[
//              TextButton(child: Text("Hủy"), 
//              onPressed: () {
//               print("Tôi là TextButton , Bạn đã nhấn tôi rồi, dừng lại đi!");
//              }
//              ),
//              OutlinedButton(child: Text("Chi tiết"), 
//              onPressed: () {
//               print("Tôi là OutlinedButton , Bạn đã nhấn tôi rồi, dừng lại đi!");
//              }
//              ),
//             IconButton(
//               icon: Icon(Icons.favorite), 
//               onPressed: () {
//               print("Tôi là IconButton, Bạn đã nhấn tôi rồi, dừng lại đi!");
//             }
//             ),
//             FloatingActionButton(child: Icon(Icons.add), onPressed: () {
//               print("Tôi là FloatingActionButton, Bạn đã nhấn tôi rồi, dừng lại đi!");
//             },
//             heroTag: 'buttonDemoFAB',
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//             onPressed: () { 
//               print("Tôi là ElevatedButton, Bạn đã nhấn tôi rồi, dừng lại đi!"); },
//             child: Text("Nhấn tôi"),
//           )
//             ],
//           ),
//         ),
//       );
//   }
// }

class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});
  @override
  _ButtonDemoScreenState createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  int counter = 0; 
  bool isFavorite = false; 

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo 5 Button trong Flutter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. TextButton: Đặt lại counter về 0
            TextButton(
              onPressed: () {
                setState(() {
                  counter = 0;
                });
                _showSnackBar("Counter đã được đặt lại!");
              },
              child: Text("Đặt lại"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),

            // 2. ElevatedButton: Tăng counter
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              onLongPress: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DemoElevated(),)
                );
              },
              child: Text("Tăng (+1)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            SizedBox(height: 20),

            // 3. OutlinedButton: Giảm counter
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (counter > 0) counter--;
                });
              },
              child: Text("Giảm (-1)"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red, width: 2),
                foregroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            // 4. IconButton
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                _showSnackBar(isFavorite ? "Đã thích!" : "Đã bỏ thích!");
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Colors.pink,
              iconSize: 40,
            ),
            IconButton(
              onPressed: (){}, 
              icon: Icon(Icons.share),
              color: Colors.blue,
            ),

            ]
          ),
            SizedBox(height: 20),

            // Hiển thị giá trị counter
            Text(
              "Giá trị hiện tại: $counter",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      // 5. FloatingActionButton: Hiển thị thông báo
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSnackBar("Bạn đã nhấn nút FAB!");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
        shape: CircleBorder(),
      ),
    );
  }
}

class DemoElevated extends StatefulWidget {
  const DemoElevated({super.key});
  @override
  _DemoElevated createState() => _DemoElevated();
}

class _DemoElevated extends State<DemoElevated> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  void _sendMessage() {
    String sender = _nameController.text;
    String message = _messageController.text;

    if (sender.isNotEmpty && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gửi thành công từ: $sender')),
      );

      // Reset form
      _nameController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gửi Tin Nhắn')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên người gửi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: _sendMessage,
                child: Text('Gửi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}