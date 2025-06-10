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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_project_presentation_lastsegment/user/user_management_screen.dart';

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
      home: HomeScreenNow(username: "Mặc Định"),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(69, 209, 253, 1), // Màu chủ đạo
        scaffoldBackgroundColor: Color.fromRGBO(249, 250, 251, 1),
      ),
    );
  }
}

class HomeScreenNow extends StatefulWidget {
  final String username; // Thêm thuộc tính nhận dữ liệu

  const HomeScreenNow({
    super.key,
    required this.username,
  }); // Constructor có tham số

  @override
  State<HomeScreenNow> createState() => HomeScreenNow_State();
}

class HomeScreenNow_State extends State<HomeScreenNow> {
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
          if (mounted) {
            setState(() {});
          }
        },
      ),
      MyApp_Devices(),
      const SchoolsScreen(),
      const UserListScreen(),

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
      ),
      MyApp_Devices(),
      const SchoolsScreen(),
      const UserListScreen(),
      MyApp_Blog_New(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        title: Text(
          "Manage School Equipments",
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
        currentIndex:
            currentPage, // thuộc tính currentIndex để xác định page hiện tại đang đứng ở đâu
        onTap: (value) {
          // khi onTap tức là 1 item của bottomnav được chọn thì sẽ nhận vào index của mục đang nhấn
          // nó là value (chỉ số mục đang nhấn, thì ontap sẽ gọi setstate và gán currentpage = với value đó)
          // từ đó currentIndex thay đổi mà crIndex thay đổi thì flutter tự động cập nhật lại giao diện
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Device"),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.school),
            label: "School",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUser),
            label: "User",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.circleInfo),
          //   label: 'About us',
          // ),
        ],
        selectedItemColor: Color.fromRGBO(69, 209, 253, 1),
        unselectedItemColor: Color.fromRGBO(75, 85, 99, 1),
        backgroundColor: Color.fromRGBO(144, 202, 249, 1),
      ),
      floatingActionButton:
          currentPage ==
                  0 // Kiểm tra nếu đang ở HomeContent
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyReport(),
                    ), // Chuyển đến màn hình báo cáo
                  );
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
              title: Text('My Assigned Tasks'),
              onTap: () async {
                Navigator.pop(context); // Đóng drawer

                final user = FirebaseAuth.instance.currentUser;
                final userEmail = user?.email;
                if (userEmail != null) {
                  final updatedReport = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TechnicianScreen(
                            technicianId:
                                userEmail, // lấy email hiện tại làm ID
                            technicians: technicians,
                          ),
                    ),
                  );

                  if (updatedReport != null && mounted) {
                    _homeContentKey.currentState?.updateReport(updatedReport);
                    setState(() {});
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Không tìm thấy thông tin người dùng"),
                    ),
                  );
                }
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

  // // Thêm phương thức công khai để cập nhật report từ bên ngoài
  // void updatedReport(Report updatedReport) {
  //   final state = createState();
  //   if (state.mounted) {
  //     state.updateReport(updatedReport);
  //   }
  // }
}

class _HomeContentState extends State<HomeContent> {
  List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    _listenToReports();
  }

  void _listenToReports() {
    FirebaseFirestore.instance
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final List<Report> loadedReports =
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

  String timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${date.day}/${date.month}/${date.year}';
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
                        onTap:
                            report.status == "Urgent"
                                ? () async {
                                  final updatedReport =
                                      await showTechnicianAssignmentScreen(
                                        context,
                                        report,
                                        widget.technicians,
                                      );
                                  if (updatedReport != null) {
                                    updateReport(updatedReport);
                                  }
                                }
                                : null, // nếu ko phải urgent thì không làm gì cả

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

Future<Report?> showTechnicianAssignmentScreen(
  BuildContext parentContext,
  Report report,
  List<Technician> technicians,
) async {
  Technician? selectedTechnician;

  return await showModalBottomSheet<Report>(
    context: parentContext,
    isScrollControlled: true,
    builder: (BuildContext modalContext) {
      return StatefulBuilder(
        builder: (BuildContext modalContext, StateSetter setModalState) {
          final availableTechnicians =
              technicians.where((t) => t.isAvailable).toList();

          return Container(
            height: MediaQuery.of(modalContext).size.height * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Phân công kỹ thuật viên",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableTechnicians.length,
                    itemBuilder: (context, index) {
                      final technician = availableTechnicians[index];
                      final isSelected = selectedTechnician == technician;

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedTechnician = technician;
                          });
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: isSelected ? 4 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color:
                                  isSelected
                                      ? Color.fromRGBO(69, 209, 253, 1)
                                      : Colors.grey.withOpacity(0.5),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  technician.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Trạng thái: Rảnh",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedTechnician != null) {
                      final user = FirebaseAuth.instance.currentUser;

                      // 🔥 Cập nhật Firestore report
                      await FirebaseFirestore.instance
                          .collection('reports')
                          .doc(report.id)
                          .update({
                            'status': 'In Progress',
                            'assignedTo': selectedTechnician!.id,
                            'updatedAt': DateTime.now(),
                            'history': FieldValue.arrayUnion([
                              {
                                'status': 'In Progress',
                                'timestamp': Timestamp.now(),
                                'updatedBy':
                                    selectedTechnician?.email ?? 'unknown',
                              },
                            ]),
                          });

                      final updatedReport = Report(
                        id: report.id,
                        title: report.title,
                        location: report.location,
                        description: report.description,
                        reportedBy: report.reportedBy,
                        status: "In Progress",
                        timestamp: report.timestamp,
                        assignedTechnicianId: selectedTechnician!.id,
                      );

                      Navigator.pop(modalContext, updatedReport);

                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Đã phân công cho ${selectedTechnician!.name}",
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(modalContext).showSnackBar(
                        SnackBar(
                          content: Text("Vui lòng chọn một kỹ thuật viên"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(69, 209, 253, 1),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  child: Text(
                    "Phân bổ ngay",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
