import 'package:flutter/material.dart';
import 'phuc_demobutton.dart';
void main() => runApp(MyApp_Blog());

class MyApp_Blog extends StatelessWidget {
  const MyApp_Blog({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppExample(), debugShowCheckedModeBanner: false,);
  }
}

class MyAppExample extends StatefulWidget {
  const MyAppExample({super.key});
  
  @override
  State<MyAppExample> createState() => _MyAppExampleState();
}

class _MyAppExampleState extends State<MyAppExample> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 5,),
              Text(
                "Blog thông tin công ty",
                style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            indicator: BoxDecoration(
              color: const Color.fromARGB(255, 239, 238, 238),
              borderRadius: BorderRadius.circular(14),
            ),
            labelColor: const Color.fromARGB(255, 13, 13, 13),
            unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255),
            tabs: [
              Tab(text: 'CÔNG TY'),
              Tab(text: 'HOẠT ĐỘNG'),
              Tab(text: 'KỸ THUẬT'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Nội dung tab CÔNG TY
            SingleChildScrollView(
              child: buildCompanyContent(),
            ),
            // Nội dung tab HOẠT ĐỘNG
            buildActiviesContent(),
            // Nội dung tab KỸ THUẬT
            buildTechContent(),
          ],
        ),
      ),
    );
  }
  
  Widget buildCompanyContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
              children: <TextSpan>[
                TextSpan(text: 'Khoa ', style: TextStyle(),),
                TextSpan(text: "Công nghệ thông tin trường Đại học Công thương thành phố Hồ Chí Minh", style: TextStyle(color: const Color.fromARGB(255, 59, 108, 148),),)
              ]
            ),
          ), 
        ),
        const SizedBox(height: 20,),
        Center(
          child: Text(
            "KHOA CÔNG NGHỆ THÔNG TIN – ĐẠI HỌC CÔNG THƯƠNG TP.HCM: NƠI CHẮP CÁNH ƯỚC MƠ TRONG KỶ NGUYÊN SỐ",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
  Widget buildActiviesContent(){
    return Container(
            margin: EdgeInsets.all(12),
            child: SizedBox(
              height: 480,
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chuyển sang demo button",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Demo các button cơ bản trong Flutter",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context)=>ButtonDemoScreen ())
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to demo"),
                              ),
                              ]
                            ),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            )
          );
  }
  Widget buildTechContent(){
    return Container(
            margin: EdgeInsets.all(12),
            child: SizedBox(
              height: 480,
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(        
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lorem ipsum odor amet",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tác giả: Phúc",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum odor amet, consectetuer adipiscing elit. Fermentum potenti erat consectetur himenaeos elementum efficitur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(127, 134, 144, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trạng thái: đang xử lý",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                                  foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Go to"),
                              ),
                              ]
                            ),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Master Class",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "5h ago",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            )
          );
  }
}


