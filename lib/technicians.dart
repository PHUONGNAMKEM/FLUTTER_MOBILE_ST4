import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/report_technician_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TechnicianScreen extends StatefulWidget {
  final String technicianId;
  final List<Technician> technicians;

  const TechnicianScreen({
    super.key,
    required this.technicianId,
    required this.technicians,
  });

  @override
  State<TechnicianScreen> createState() => _TechnicianScreenState();
}

//chổ để load danh sách task của nhân viên đang login hiện tải để xác nhận là đã hoàn thành công việc được giao hay chưa
class _TechnicianScreenState extends State<TechnicianScreen> {
  List<Report> assignedReports = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedReports();
  }

  void fetchAssignedReports() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    // 🔍 Lấy technicianId từ collection `technicians` theo email
    final techSnap =
        await FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

    // if (techSnap.docs.isEmpty) {
    //   print("❌ Technician not found for email: $userEmail");
    //   return;
    // }

    final technicianId = techSnap.docs.first.id;

    // print("🛠 Technician ID resolved: $technicianId");

    // 🔍 Truy vấn các report được giao theo ID vừa lấy
    final reportSnap =
        await FirebaseFirestore.instance
            .collection('reports')
            .where('assignedTo', isEqualTo: technicianId)
            .where('status', whereIn: ['In Progress', 'Completed'])
            .get();

    // print("🔍 Số lượng report lấy được: ${reportSnap.docs.length}");

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

                // setState(() {
                //   report.status = 'Completed';
                //   assignedReports.removeWhere((r) => r.id == report.id);
                // });
                fetchAssignedReports();
              },
              child: Text("Rồi"),
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
        title: Text("Assigned Tasks", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Tasks",
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
                          onTap: () {
                            if (report.status == "In Progress") {
                              _showCompletionDialog(context, report);
                            }
                          },
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
                                                  : report.status ==
                                                      "In Progress"
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
                                                  ? Color.fromRGBO(
                                                    225,
                                                    67,
                                                    67,
                                                    1,
                                                  )
                                                  : report.status ==
                                                      "In Progress"
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
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    report.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(127, 134, 144, 1),
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
                                          color: Color.fromRGBO(
                                            127,
                                            134,
                                            144,
                                            1,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "5h ago",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(
                                            127,
                                            134,
                                            144,
                                            1,
                                          ),
                                        ),
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
      ),
    );
  }
}
