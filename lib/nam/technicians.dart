import 'package:flutter/material.dart';
import 'package:flutter_project_presentation_lastsegment/nam/report_technician_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TechnicianScreen extends StatefulWidget {
  final List<Technician> technicians;
  final String technicianId; // ID của kỹ thuật viên đang xem

  const TechnicianScreen({
    super.key,
    required this.technicians,
    required this.technicianId,
  });

  @override
  State<TechnicianScreen> createState() => _TechnicianScreenState();
}

class _TechnicianScreenState extends State<TechnicianScreen> {
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
                Navigator.pop(dialogContext); // Đóng hộp thoại nếu chọn "Chưa"
              },
              child: Text("Chưa"),
            ),
            TextButton(
              onPressed: () {
                // Cập nhật trạng thái report thành "Completed"
                setState(() {
                  report.status = "Completed";
                  // Tìm kỹ thuật viên và cập nhật trạng thái
                  final technician = widget.technicians.firstWhere(
                    (t) => t.id == widget.technicianId,
                  );
                  technician.isAvailable =
                      true; // Kỹ thuật viên trở lại trạng thái rảnh
                  // technician.assignedReports.removeWhere(
                  //   (r) => r.id == report.id,
                  // ); // Xóa report khỏi danh sách phân công
                });

                // Trả dữ liệu về HomeContent để cập nhật UI
                Navigator.pop(dialogContext); // Đóng hộp thoại
                Navigator.pop(
                  context,
                  report,
                ); // Trả report đã cập nhật về màn hình trước
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
    // Lọc các report được phân công cho kỹ thuật viên này
    final assignedReports =
        widget.technicians
            .firstWhere((t) => t.id == widget.technicianId)
            .assignedReports;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 209, 253, 1),
        title: Text(
          "Assigned Tasks",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
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
                              // Chỉ hiển thị dialog nếu trạng thái là "In Progress"
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
                                          color: Color.fromRGBO(
                                            127,
                                            134,
                                            144,
                                            1,
                                          ),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "5h ago", // Có thể thay bằng logic thời gian thực
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
