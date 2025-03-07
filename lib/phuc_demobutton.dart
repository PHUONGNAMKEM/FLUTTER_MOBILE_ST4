import 'package:flutter/material.dart';

void main() => runApp(const ButtonExampleApp());

class ButtonExampleApp extends StatelessWidget {
  const ButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Button Demo'),
        ),
        body: Center(
          child: OverflowBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
             TextButton(child: Text("Hủy"), 
             onPressed: () {
              print("Tôi là TextButton , Bạn đã nhấn tôi rồi, dừng lại đi!");
             }
             ),
             OutlinedButton(child: Text("Chi tiết"), 
             onPressed: () {
              print("Tôi là OutlinedButton , Bạn đã nhấn tôi rồi, dừng lại đi!");
             }
             ),
            IconButton(
              icon: Icon(Icons.favorite), 
              onPressed: () {
              print("Tôi là IconButton, Bạn đã nhấn tôi rồi, dừng lại đi!");
            }
            ),
            FloatingActionButton(child: Icon(Icons.add), onPressed: () {
              print("Tôi là FloatingActionButton, Bạn đã nhấn tôi rồi, dừng lại đi!");
            },
            heroTag: 'buttonDemoFAB',
            ),
            const SizedBox(width: 10),
            ElevatedButton(
            onPressed: () { 
              print("Tôi là ElevatedButton, Bạn đã nhấn tôi rồi, dừng lại đi!"); },
            child: Text("Nhấn tôi"),
          )
            ],
          ),
        ),
      );
  }
}
