import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/Schools.dart';
import 'package:flutter_project_presentation_lastsegment/blog.dart';
import 'package:flutter_project_presentation_lastsegment/device.dart';
import 'package:flutter_project_presentation_lastsegment/nam_demonhanh_dialog.dart';

// import 'package:flutter_project_presentation_lastsegment/nam/phancong.dart';

import 'package:flutter_project_presentation_lastsegment/phong_newreport.dart';
import 'package:flutter_project_presentation_lastsegment/report_technician_model.dart';
import 'package:flutter_project_presentation_lastsegment/son_loginScreen.dart';
import 'package:flutter_project_presentation_lastsegment/technicians.dart';
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
      home: HomeScreenTechnician(username: "Mặc Định"),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(69, 209, 253, 1), // Màu chủ đạo
        scaffoldBackgroundColor: Color.fromRGBO(249, 250, 251, 1),
      ),
    );
  }
}

class HomeScreenTechnician extends StatefulWidget {
  final String username; // Thêm thuộc tính nhận dữ liệu

  const HomeScreenTechnician({
    super.key,
    required this.username,
  }); // Constructor có tham số

  @override
  State<HomeScreenTechnician> createState() => HomeScreenNow_State();
}

class HomeScreenNow_State extends State<HomeScreenTechnician> {
  int currentPage = 0;
  List<Technician> technicians = [];

  // Thêm GlobalKey cho HomeContent
  final GlobalKey<_HomeContentState> _homeContentKey =
      GlobalKey<_HomeContentState>();

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _loadTechnicians(); // 🔍 load từ Firestore
    pages = [
      HomeContent(
        key: _homeContentKey,
        technicians: technicians,
        onReportUpdated: (updatedReport) {
          if (mounted) setState(() {});
        },
      ),
      Center(child: Text('Info page')), // Tạm thời
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
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        title: Text(
          "Technician Page",
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
  const HomeContent({
    super.key,
    required this.technicians,
    required this.onReportUpdated,
  });
  final List<Technician> technicians;
  final Function(Report) onReportUpdated;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Report> assignedReports = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedReports();
  }

  void fetchAssignedReports() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final techSnap =
        await FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

    final technicianId = techSnap.docs.first.id;

    final reportSnap =
        await FirebaseFirestore.instance
            .collection('reports')
            .where('assignedTo', isEqualTo: technicianId)
            .where('status', whereIn: ['In Progress', 'Completed'])
            .orderBy('createdAt', descending: true)
            .get();

    setState(() {
      assignedReports =
          reportSnap.docs.map((doc) => Report.fromFirestore(doc)).toList();
    });
  }

  void _showCompletionDialog(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Xác nhận hoàn thành"),
          content: Text("Bạn đã hoàn thành nhiệm vụ này chưa?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text("Chưa"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                final user = FirebaseAuth.instance.currentUser;

                await FirebaseFirestore.instance
                    .collection('reports')
                    .doc(report.id)
                    .update({
                      'status': 'Completed',
                      'updatedAt': DateTime.now(),
                      'history': FieldValue.arrayUnion([
                        {
                          'status': 'Completed',
                          'timestamp': Timestamp.now(),
                          'updatedBy': user?.email ?? 'unknown',
                        },
                      ]),
                    });

                fetchAssignedReports(); // cập nhật lại danh sách
              },
              child: Text("Rồi"),
            ),
          ],
        );
      },
    );
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
      return assignedReports.where((r) => r.status == "Urgent").length;
    }
    return assignedReports.where((r) => r.status == status).length;
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
        Expanded(
          child:
              assignedReports.isEmpty
                  ? Center(child: Text("No tasks assigned yet"))
                  : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: assignedReports.length,
                    itemBuilder: (context, index) {
                      final report = assignedReports[index];
                      return GestureDetector(
                        onTap:
                            report.status == "In Progress"
                                ? () => _showCompletionDialog(context, report)
                                : null,
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
                                      "Reported by: ${report.reportedBy}",
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
                    },
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
