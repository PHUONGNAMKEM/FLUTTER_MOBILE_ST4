import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/Schools.dart';
import 'package:flutter_project_presentation_lastsegment/blog.dart';
import 'package:flutter_project_presentation_lastsegment/device.dart';
import 'package:flutter_project_presentation_lastsegment/nam_demonhanh_dialog.dart';

// import 'package:flutter_project_presentation_lastsegment/nam/phancong.dart';

import 'package:flutter_project_presentation_lastsegment/phong_newreport_teacher.dart';
import 'package:flutter_project_presentation_lastsegment/report_technician_model.dart';
import 'package:flutter_project_presentation_lastsegment/son_loginScreen.dart';
import 'package:flutter_project_presentation_lastsegment/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // RẤT QUAN TRỌNG
  runApp(LoginScreen_App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenTeacher(
        username: "Mặc Định",
        schoolId: "DHCT", // hoặc null nếu chưa có
        classId: "13DHTH02", // hoặc null nếu chưa có
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(69, 209, 253, 1), // Màu chủ đạo
        scaffoldBackgroundColor: Color.fromRGBO(249, 250, 251, 1),
      ),
    );
  }
}

class HomeScreenTeacher extends StatefulWidget {
  final String username;
  final String? schoolId;
  final String? classId;

  const HomeScreenTeacher({
    super.key,
    required this.username,
    required this.schoolId,
    required this.classId,
  });

  @override
  State<HomeScreenTeacher> createState() => HomeScreenNow_State();
}

class HomeScreenNow_State extends State<HomeScreenTeacher> {
  int currentPage = 0;
  List<Technician> technicians = [];
  String? schoolId;
  String? classId;

  // Thêm GlobalKey cho HomeContent
  final GlobalKey<_HomeContentState> _homeContentKey =
      GlobalKey<_HomeContentState>();

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    schoolId = widget.schoolId;
    classId = widget.classId;
    _loadTechnicians(); //
    pages = [
      HomeContent(
        key: _homeContentKey,
        technicians: technicians,
        onReportUpdated: (updatedReport) {
          if (mounted) setState(() {});
        },
        schoolId: widget.schoolId,
        classId: widget.classId,
      ),
      MyApp_Devices(),
      const SchoolsScreen(),
      MyApp_Users(),

      // const MyApp_Blog(),
      MyApp_Blog_New(),
    ];
  }

  void _loadTechnicians() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('user')
            .where('role', isEqualTo: 'technician')
            .get();
    final loadedTechnicians =
        snapshot.docs.map((doc) => Technician.fromFirestore(doc)).toList();

    setState(() {
      technicians = loadedTechnicians;
      pages = _buildPages(); // Gọi lại cập nhật giao diện
    });
  }

  List<Widget> _buildPages() {
    return [
      HomeContent(
        key: _homeContentKey,
        technicians: technicians,
        onReportUpdated: (updatedReport) {
          if (mounted) setState(() {});
        },
        schoolId: schoolId,
        classId: classId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        title: Text(
          "Teacher Page",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext leadingContext) {
            return Padding(
              padding: EdgeInsets.zero,
              child: IconButton(
                // icon: FaIcon(FontAwesomeIcons.bars, color: Colors.white, size: 24,),
                icon: Icon(Icons.menu, color: Colors.white, size: 24),
                onPressed: () {
                  Scaffold.of(leadingContext).openDrawer();
                },
              ),
            );
          },
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen_App()),
              );
            },
          ),
        ],
      ),
      body: pages[currentPage],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "Info",
          ),
        ],
      ),
      floatingActionButton:
          currentPage ==
                  0 // Kiểm tra nếu đang ở HomeContent
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyTeacherReport()),
                  ).then((_) {
                    // 🔁 Gọi lại hàm để đảm bảo trang này lấy đúng report mới
                    _homeContentKey.currentState?.refreshReports();
                  });
                },
                backgroundColor: Color.fromRGBO(69, 209, 253, 1),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(69, 209, 253, 1)),
              child: Center(
                child: Text(
                  'Hello, ${widget.username} !',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
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
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                print('Navigated to Settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Home Page
class HomeContent extends StatefulWidget {
  final String? schoolId;
  final String? classId;

  const HomeContent({
    super.key,
    required this.technicians,
    required this.onReportUpdated,
    required this.schoolId,
    required this.classId,
  });

  final List<Technician> technicians;
  final Function(Report) onReportUpdated;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Report> reports = [];
  @override
  void initState() {
    super.initState();
    print(
      '📌 HomeContent loaded with schoolId=${widget.schoolId}, classId=${widget.classId}',
    );
    _listenToReports(); // gọi trực tiếp
  }

  void refreshReports() {
    _listenToReports(); // Gọi lại hàm cũ
  }

  void _listenToReports() {
    if (widget.schoolId == null || widget.classId == null) return;

    FirebaseFirestore.instance
        .collection('reports')
        .where('schoolId', isEqualTo: widget.schoolId)
        .where('classId', isEqualTo: widget.classId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final loadedReports =
              snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();

          setState(() {
            reports = loadedReports;
          });
        });
  }

  void updateReport(Report updatedReport) {
    FirebaseFirestore.instance
        .collection('reports')
        .doc(updatedReport.id)
        .update({
          'status': updatedReport.status,
          'assignedTo': updatedReport.assignedTechnicianId,
          'updatedAt': DateTime.now(),
        });
  }

  int countStatus(String status) {
    if (status == "Pending") {
      return reports.where((r) => r.status == "Urgent").length;
    }
    return reports.where((r) => r.status == status).length;
  }

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
                  padding: EdgeInsets.only(
                    bottom: 6,
                  ), // Sửa lỗi typo: 'bottom' thay vì 'custom'
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
                          "${countStatus("Urgent")}", // Urgent xem như Pending
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(224, 62, 62, 1),
                          ),
                        ),
                        Text("Urgent", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${countStatus("In Progress")}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(237, 188, 37, 1),
                          ),
                        ),
                        Text(
                          "In Progress",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${countStatus("Completed")}",
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
              Text("View All", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(12),
          child: SizedBox(
            height: 480,
            child: SingleChildScrollView(
              child: Column(
                children:
                    reports.map((report) {
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      report.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            report.status == "Urgent"
                                                ? Color.fromRGBO(
                                                  254,
                                                  226,
                                                  226,
                                                  1,
                                                )
                                                : report.status == "In Progress"
                                                ? Color.fromRGBO(
                                                  254,
                                                  249,
                                                  195,
                                                  1,
                                                )
                                                : Color.fromRGBO(
                                                  220,
                                                  252,
                                                  231,
                                                  1,
                                                ),
                                        foregroundColor:
                                            report.status == "Urgent"
                                                ? Color.fromRGBO(225, 67, 67, 1)
                                                : report.status == "In Progress"
                                                ? Color.fromRGBO(
                                                  206,
                                                  148,
                                                  22,
                                                  1,
                                                )
                                                : Color.fromRGBO(
                                                  24,
                                                  164,
                                                  76,
                                                  1,
                                                ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        elevation: 1,
                                      ),
                                      child: Text(report.status),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  report.location,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(127, 134, 144, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  report.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(127, 134, 144, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${report.reportedBy}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(127, 134, 144, 1),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "5h ago", // Có thể thay bằng logic tính thời gian thực
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                              127,
                                              134,
                                              144,
                                              1,
                                            ),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => HistoryScreen(
                                                      history: report.history,
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.history_sharp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
//  Report Page
// Mình sẽ đổi giao diện qua bên file report.dart

// Stats Page
// Mình sẽ chuyển hướng giao diện qua file stats.dart

// Giao diện History của Reports

class HistoryScreen extends StatelessWidget {
  final List<ReportHistory> history;

  const HistoryScreen({required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report history")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final entry = history[index];

          // Màu nền theo trạng thái
          final bgColor =
              entry.status == "Urgent"
                  ? Color.fromRGBO(254, 226, 226, 1)
                  : entry.status == "In Progress"
                  ? Color.fromRGBO(254, 249, 195, 1)
                  : Color.fromRGBO(220, 252, 231, 1);

          // Màu chữ theo trạng thái
          final textColor =
              entry.status == "Urgent"
                  ? Color.fromRGBO(225, 67, 67, 1)
                  : entry.status == "In Progress"
                  ? Color.fromRGBO(206, 148, 22, 1)
                  : Color.fromRGBO(24, 164, 76, 1);

          return Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dòng hiển thị người cập nhật và trạng thái
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.updatedBy,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          entry.status,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')} ${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(127, 134, 144, 1),
                      fontWeight: FontWeight.w400,
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
