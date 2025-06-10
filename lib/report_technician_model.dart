import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String id;
  String title;
  String location;
  String description;
  String reportedBy;
  String status;
  DateTime timestamp;
  String? assignedTechnicianId;
  List<ReportHistory> history;

  Report({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.reportedBy,
    required this.status,
    required this.timestamp,
    this.assignedTechnicianId,
    this.history = const [],
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final historyList =
        (data['history'] as List<dynamic>? ?? []).map((h) {
          return ReportHistory.fromMap(h as Map<String, dynamic>);
        }).toList();

    return Report(
      id: doc.id,
      title: data['deviceId'] ?? '',
      location: data['classId'] ?? '',
      description: data['description'] ?? '',
      reportedBy: data['reporterId'] ?? '',
      status: data['status'] ?? '',
      timestamp: (data['createdAt'] as Timestamp).toDate(),
      assignedTechnicianId: data['assignedTo'],
      history: historyList,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'deviceId': title,
    'classId': location,
    'description': description,
    'reporterId': reportedBy,
    'status': status,
    'assignedTo': assignedTechnicianId,
    'createdAt': timestamp,
    'history': history.map((h) => h.toMap()).toList(),
  };
}

class ReportHistory {
  final String status;
  final DateTime timestamp;
  final String updatedBy;

  ReportHistory({
    required this.status,
    required this.timestamp,
    required this.updatedBy,
  });

  factory ReportHistory.fromMap(Map<String, dynamic> map) {
    return ReportHistory(
      status: map['status'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      updatedBy: map['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'updatedBy': updatedBy,
    };
  }
}

class Technician {
  String id;
  String name;
  String email; // 👈 Thêm dòng này
  bool isAvailable;
  List<Report> assignedReports;

  Technician({
    required this.id,
    required this.name,
    required this.email,
    required this.isAvailable,
    this.assignedReports = const [],
  });

  factory Technician.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Technician(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
    );
  }
}
