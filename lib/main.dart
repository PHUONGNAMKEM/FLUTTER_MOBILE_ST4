
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_project_presentation_lastsegment/hoangphuc_blog.dart';
=======
import 'package:flutter_project_presentation_lastsegment/nam_demonhanh_dialog.dart';
>>>>>>> ef554895abe6899702abffb5f141cc374dd64637
import 'package:flutter_project_presentation_lastsegment/profile.dart';
import 'package:flutter_project_presentation_lastsegment/report.dart';
import 'package:flutter_project_presentation_lastsegment/stats.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

// class AppTheme {  
//   static ThemeData myTheme = ThemeData(  
//     primaryColor: const Color.fromRGBO(69, 209, 253, 1), // Màu chủ đạo  
//     hintColor: const Color.fromRGBO(31, 188, 253, 1), // Màu phụ - đậm hơn
//     scaffoldBackgroundColor: Colors.white, // Màu nền của Scaffold  
//     appBarTheme: AppBarTheme(  
//       backgroundColor: Color.fromRGBO(69, 209, 253, 1), // Màu AppBar 
//       titleTextStyle: TextStyle(  
//         color: Colors.white,  
//         fontSize: 20,  
//         fontWeight: FontWeight.w600,  
//       ),  
//     ),  
//     textTheme: TextTheme(  
//       bodyLarge: TextStyle(color: Colors.black87),  
//       bodyMedium: TextStyle(color: Colors.black54),  
//     ),  
//     // Bạn có thể tùy chỉnh thêm các thuộc tính khác như buttonColor, cardColor, v.v.  
//   );  
// }  

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenNow(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(69, 209, 253, 1), // Màu chủ đạo
        scaffoldBackgroundColor: Color.fromRGBO(249, 250, 251, 1),
      ),
    );
  }
}

class HomeScreenNow extends StatefulWidget {
  const HomeScreenNow({super.key});
  
  @override
  State<HomeScreenNow> createState() => HomeScreenNow_State();
}

class HomeScreenNow_State extends State<HomeScreenNow> {

  int currentPage = 0;

  // Thêm ở đây 1 list các page mà mình muốn chuyển hướng trong navigation bar
  final List<Widget> pages = [
    const HomeContent(),
    const MyApp_Report(),
    const MyApp_Stats(),
    const MyApp_Profile(),
    const MyApp_Blog(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        title: Text("Manage School Equipments", style: TextStyle(color: Colors.white, fontSize: 20)),
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
      body: pages[currentPage],
       
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage, // thuộc tính currentIndex để xác định page hiện tại đang đứng ở đâu
        onTap: (value) { // khi onTap tức là 1 item của bottomnav được chọn thì sẽ nhận vào index của mục đang nhấn
        // nó là value (chỉ số mục đang nhấn, thì ontap sẽ gọi setstate và gán currentpage = với value đó)
        // từ đó currentIndex thay đổi mà crIndex thay đổi thì flutter tự động cập nhật lại giao diện 
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.fileInvoice), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.chartBar), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.solidUser), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.circleInfo), label: "About us"),
        ],
        selectedItemColor: Color.fromRGBO(69, 209, 253, 1), 
        unselectedItemColor: Color.fromRGBO(75,85,99, 1),
        backgroundColor: Color.fromRGBO(144, 202, 249, 1), 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReportScreen()),
          );
        },
        backgroundColor: Color.fromRGBO(69, 209, 253, 1), 
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

}

// Widget cho trang Add Report
class AddReportScreen extends StatelessWidget {
  const AddReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Report"),
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
      ),
      body: Center(
        child: Text("This is Add Report Screen"),
      ),
    );
  }
}


// Home Page 
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Quick Stats",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 44, 43, 43),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "12",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(224, 62, 62, 1),
                            ),
                          ),
                          Text("Pending", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "8",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(237, 188, 37, 1),
                            ),
                          ),
                          Text("In Progress", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "45",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(34, 197, 94, 1),
                            ),
                          ),
                          Text("Completed", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Reports",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Text(
                  "View All",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
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
                                "Projector Malfunction",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(254, 226, 226, 1),
                                  foregroundColor: Color.fromRGBO(225, 67, 67, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Urgent"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Room A206",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Screen flickering and no display output",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
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
                                "AC Not Cooling",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(254, 249, 195, 1),
                                  foregroundColor: Color.fromRGBO(206, 148, 22, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("In Progress"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Library",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Temperature control not working properly",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reported by: Staff Library",
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
                                "Smart Board Issue",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(220, 252, 231, 1),
                                  foregroundColor: Color.fromRGBO(24, 164, 76, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 1,
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                child: Text("Completed"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Room B501",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Screen flickering and no display output",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(127, 134, 144, 1),
                                  fontWeight: FontWeight.w400,
                                ),
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
          ),
        ],
      );
  }
}

//  Report Page
// Mình sẽ đổi giao diện qua bên file report.dart

// Stats Page
// Mình sẽ chuyển hướng giao diện qua file stats.dart

