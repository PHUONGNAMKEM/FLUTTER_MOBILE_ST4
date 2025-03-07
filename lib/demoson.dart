import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_project_presentation_lastsegment/main.dart';
import 'package:flutter_project_presentation_lastsegment/nam_demonhanh_dialog.dart';
import 'package:flutter_project_presentation_lastsegment/son_loginScreen.dart';
import 'package:flutter_project_presentation_lastsegment/profile.dart';
import 'package:flutter_project_presentation_lastsegment/report.dart';
import 'package:flutter_project_presentation_lastsegment/stats.dart';

void main() {
  runApp(
    MaterialApp(home: DemoFormScreen(), debugShowCheckedModeBanner: false),
  );
}

class DemoFormScreen extends StatefulWidget {
  @override
  _DemoFormScreenState createState() => _DemoFormScreenState();
}

class _DemoFormScreenState extends State<DemoFormScreen> {
  TextEditingController nameController = TextEditingController();

  String? gender; // Radio Button
  bool likesCoding = false; // Checkbox
  bool likesMusic = false;

  String selectedCountry = "Việt Nam"; // Dropdown

  void _submitForm() {
    String name = nameController.text;

    String genderText = gender ?? "Chưa chọn";
    String hobbies = "";
    if (likesCoding) hobbies += "Lập trình, ";
    if (likesMusic) hobbies += "Âm nhạc, ";
    hobbies =
        hobbies.isEmpty
            ? "Chưa chọn"
            : hobbies.substring(0, hobbies.length - 2);

    // Hiển thị dữ liệu nhập vào
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thông tin người dùng"),
          content: Text(
            "Tên: $name\nGiới tính: $genderText\nSở thích: $hobbies\nQuốc gia: $selectedCountry",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        title: Text(
          "Demo Form",
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
          ),
        ),
        titleSpacing: 0,
        leading: Padding(
          padding: EdgeInsets.zero,
          child: IconButton(
            // icon: FaIcon(FontAwesomeIcons.bars, color: Colors.white, size: 24,),
            icon: Icon(Icons.menu, color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppDiaLog()),
              );
            },
          ),
          IconButton(
            // icon: Icon(Icons.person, color: Colors.white),
            icon: FaIcon(FontAwesomeIcons.circleUser, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nhập tên
            Text("Tên:", style: TextStyle(fontSize: 16)),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 0, 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nhập tên của bạn",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Chọn giới tính
            Text("Giới tính:", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Radio(
                  value: "Nam",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value as String?;
                    });
                  },
                ),
                Text("Nam"),
                SizedBox(width: 20),
                Radio(
                  value: "Nữ",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value as String?;
                    });
                  },
                ),
                Text("Nữ"),
              ],
            ),
            SizedBox(height: 16),

            // Chọn sở thích
            Text("Sở thích:", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Checkbox(
                  value: likesCoding,
                  onChanged: (value) {
                    setState(() {
                      likesCoding = value!;
                    });
                  },
                ),
                Text("Lập trình"),
                SizedBox(width: 20),
                Checkbox(
                  value: likesMusic,
                  onChanged: (value) {
                    setState(() {
                      likesMusic = value!;
                    });
                  },
                ),
                Text("Âm nhạc"),
              ],
            ),
            SizedBox(height: 16),
            Text("Chọn quốc gia:", style: TextStyle(fontSize: 16)),

            // Dropdown chọn quốc gia
            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedCountry,
                    items:
                        ["Việt Nam", "Mỹ", "Nhật Bản", "Hàn Quốc", "Pháp"]
                            .map(
                              (country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Nút Submit
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text("Xác nhận"),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen_App()),
                );
              },
              child: Text("Quay Lại Login Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
