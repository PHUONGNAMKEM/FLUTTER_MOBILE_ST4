import 'package:flutter/material.dart';

void main() {
  runApp(MyAppDiaLog());
}

class MyAppDiaLog extends StatefulWidget {
  const MyAppDiaLog({super.key});

  @override
  _MyAppDiaLogState createState() => _MyAppDiaLogState();
}

class _MyAppDiaLogState extends State<MyAppDiaLog> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scaffold Demo'),
          backgroundColor: Colors.blue,
          leading: Builder(
            builder : (BuildContext scaffoldContext) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  // Mở drawer
                  Scaffold.of(scaffoldContext).openDrawer();
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                print('Search pressed!');
              },
            ),
            const SizedBox(width: 8,),
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context); // Quay về trang trước
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'This is the main content!',
                style: TextStyle(fontSize: 20),
              ),
              Builder(
                builder: (BuildContext scaffoldContext) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showSnackBar(scaffoldContext);
                        },
                        child: Text('Show SnackBar'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showAlertDialog(scaffoldContext),
                        child: Text('Show AlertDialog'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showSimpleDialog(scaffoldContext),
                        child: Text('Show SimpleDialog'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showCustomDialog(scaffoldContext),
                        child: Text('Show Custom Dialog'),
                      ),
                    ],
                  );
                }
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('FAB pressed!');
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue
                  //   gradient: LinearGradient(
                  //     colors: [Colors.blue, Colors.blueAccent], // Gradient màu cho header
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //   ),
                  //   borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(20.0),
                  //     bottomRight: Radius.circular(20.0),
                  //   ),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black26,
                  //       blurRadius: 10.0,
                  //       offset: Offset(0, 4),
                  //     ),
                  //   ],
                  // ),
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Đóng drawer
                  print('Navigated to Home');
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  print('Navigated to Settings');
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            print('Selected tab: $index');
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
        backgroundColor: Colors.grey[200],
        persistentFooterButtons: [
          TextButton(
            onPressed: () {
              print('Footer button pressed!');
            },
            child: Text('Footer Action'),
          ),
        ],
      );
  }

  // hiển thị SnackBar
  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This is a SnackBar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            print('Undo action!');
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // hiển thị AlertDialog
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Action'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Đóng dialog
                print('Canceled');
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Đóng dialog
                print('Confirmed');
              },
              child: Text('Delete'),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 24.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        );
      },
    );
  }

  // Hiển thị SimpleDialog
  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text('Select an Option'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'Option 1');
                print('Selected: Option 1');
              },
              child: Text('Option 1'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'Option 2');
                print('Selected: Option 2');
              },
              child: Text('Option 2'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị Dialog tùy chỉnh
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 16.0,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Custom Dialog',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('This is a custom dialog with flexible content.'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    print('Custom Dialog Closed');
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}