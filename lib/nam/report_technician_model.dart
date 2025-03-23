class Report {
  String id;
  String title;
  String location;
  String description;
  String reportedBy;
  String status;
  DateTime timestamp;
  String? assignedTechnicianId;

  Report({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.reportedBy,
    required this.status,
    required this.timestamp,
    this.assignedTechnicianId,
  });
}

class Technician {
  String id;
  String name;
  bool isAvailable;
  List<Report> assignedReports; // Phải là mutable list, không dùng const

  Technician({
    required this.id,
    required this.name,
    required this.isAvailable,
    this.assignedReports = const [], // Sai: const làm danh sách bất biến
  });

  // Sửa lại constructor để danh sách có thể thay đổi
  Technician.fixed({
    required this.id,
    required this.name,
    required this.isAvailable,
    List<Report>? assignedReports,
  }) : assignedReports = assignedReports ?? []; // Khởi tạo mutable list
}
