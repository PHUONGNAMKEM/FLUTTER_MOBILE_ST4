import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/Schools.dart';
import 'package:flutter_project_presentation_lastsegment/nam/nam_demonhanh_dialog.dart';
// import 'package:flutter_project_presentation_lastsegment/nam/phancong.dart';
import 'package:flutter_project_presentation_lastsegment/nam/report_technician_model.dart';
import 'package:flutter_project_presentation_lastsegment/nam/technicians.dart';
import 'package:flutter_project_presentation_lastsegment/phong_newreport.dart';
import 'package:flutter_project_presentation_lastsegment/son_loginScreen.dart';
import 'package:flutter_project_presentation_lastsegment/profile.dart';
import 'package:flutter_project_presentation_lastsegment/report.dart';
import 'package:flutter_project_presentation_lastsegment/stats.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_project_presentation_lastsegment/hoangphuc_blog.dart';

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
  final List<Technician> technicians = [
    Technician.fixed(id: "1", name: "Nguyễn Văn A", isAvailable: true),
    Technician.fixed(id: "2", name: "Trần Thị B", isAvailable: true),
    Technician.fixed(id: "3", name: "Lê Văn C", isAvailable: false),
  ];

  // Thêm GlobalKey cho HomeContent
  final GlobalKey<_HomeContentState> _homeContentKey =
      GlobalKey<_HomeContentState>();

  // // Thêm ở đây 1 list các page mà mình muốn chuyển hướng trong navigation bar
  // late final List<Widget> pages = [
  //   HomeContent(technicians: technicians),
  //   const MyApp_Report(),
  //   const MyApp_Stats(),
  //   const MyApp_Profile(),
  //   const MyApp_Blog(),
  //   //const LoginScreen_App()
  // ];
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeContent(
        key: _homeContentKey,
        technicians: technicians,
        onReportUpdated: (updatedReport) {
          if (mounted) {
            // Gọi setState để cập nhật giao diện nếu cần
            setState(() {});
          }
        },
      ),
      const MyApp_Report(),
      const SchoolsScreen(),
      const MyApp_Profile(),
      const MyApp_Blog(),
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
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.fileInvoice),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.school),
            label: "School",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUser),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.circleInfo),
            label: 'About us',
          ),
        ],
        selectedItemColor: Color.fromRGBO(69, 209, 253, 1),
        unselectedItemColor: Color.fromRGBO(75, 85, 99, 1),
        backgroundColor: Color.fromRGBO(144, 202, 249, 1),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => MyReport()),
      //     );
      //   },
      //   backgroundColor: Color.fromRGBO(69, 209, 253, 1),
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
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
              title: Text('Technician View'),
              onTap: () async {
                Navigator.pop(context); // Đóng drawer
                final updatedReport = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TechnicianScreen(
                          technicians: technicians,
                          technicianId: "1", // ID của kỹ thuật viên
                        ),
                  ),
                );
                if (updatedReport != null && mounted) {
                  // Sử dụng GlobalKey để truy cập trạng thái hiện tại của HomeContent
                  _homeContentKey.currentState?.updateReport(updatedReport);
                  setState(() {});
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
  // Danh sách report mẫu
  List<Report> reports = [
    Report(
      id: "1",
      title: "Projector Malfunction",
      location: "Room A206",
      description: "Screen flickering and no display output",
      reportedBy: "Master Class",
      status: "Urgent",
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Report(
      id: "2",
      title: "AC Not Cooling",
      location: "Library",
      description: "Temperature control not working properly",
      reportedBy: "Staff Library",
      status: "In Progress",
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Report(
      id: "3",
      title: "Smart Board Issue",
      location: "Room B501",
      description: "Screen flickering and no display output",
      reportedBy: "Master Class",
      status: "Completed",
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
    ),
  ];

  void updateReport(Report updatedReport) {
    if (mounted) {
      setState(() {
        int index = reports.indexWhere((r) => r.id == updatedReport.id);
        if (index != -1) {
          reports[index] = updatedReport; // Cập nhật report trong danh sách
          widget.onReportUpdated(updatedReport); // Gọi callback nếu cần
          print("🔄 Updated report in HomeContent: ${reports[index].status}");
        } else {
          print("⚠️ Report not found: ${updatedReport.id}");
        }
      });
    }
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
                        Text(
                          "In Progress",
                          style: TextStyle(color: Colors.grey),
                        ),
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
                                                      reports: reports,
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
  final List<Report> reports;

  const HistoryScreen({required this.reports, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reported by: ${report.reportedBy}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              report.status == "Urgent"
                                  ? Color.fromRGBO(254, 226, 226, 1)
                                  : report.status == "In Progress"
                                  ? Color.fromRGBO(254, 249, 195, 1)
                                  : Color.fromRGBO(220, 252, 231, 1),
                          foregroundColor:
                              report.status == "Urgent"
                                  ? Color.fromRGBO(225, 67, 67, 1)
                                  : report.status == "In Progress"
                                  ? Color.fromRGBO(206, 148, 22, 1)
                                  : Color.fromRGBO(24, 164, 76, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
                    "${report.timestamp.hour}:${report.timestamp.minute} ${report.timestamp.day}/${report.timestamp.month}/${report.timestamp.year}",
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
                            print("👆 Selected technician: ${technician.name}");
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
                  onPressed: () {
                    if (selectedTechnician != null) {
                      print(
                        "🚀 Assigning report ID ${report.id} to ${selectedTechnician!.name}",
                      );
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
                      setModalState(() {
                        selectedTechnician!.isAvailable = false;
                        selectedTechnician!.assignedReports.add(updatedReport);
                        print(
                          "✅ Technician ${selectedTechnician!.name} updated: isAvailable = ${selectedTechnician!.isAvailable}",
                        );
                      });
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Đã phân công cho ${selectedTechnician!.name}",
                          ),
                        ),
                      );
                      Navigator.pop(
                        modalContext,
                        updatedReport,
                      ); // Đóng bottom sheet
                      print(
                        "⬅️ Popped bottom sheet with updated report: ${updatedReport.status}",
                      );
                    } else {
                      ScaffoldMessenger.of(modalContext).showSnackBar(
                        SnackBar(
                          content: Text("Vui lòng chọn một kỹ thuật viên"),
                        ),
                      );
                      print("⚠️ No technician selected");
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
