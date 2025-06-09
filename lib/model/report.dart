import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String schoolId;
  final String classId;
  final String deviceId;
  final String reporterId;
  final String description;
  final String status;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report({
    required this.id,
    required this.schoolId,
    required this.classId,
    required this.deviceId,
    required this.reporterId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
  });

  // Tạo từ Firestore document
  factory Report.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Report(
      id: doc.id,
      schoolId: data['schoolId'] ?? '',
      classId: data['classId'] ?? '',
      deviceId: data['deviceId'] ?? '',
      reporterId: data['reporterId'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'Urgent',
      assignedTo: data['assignedTo'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Chuyển object thành Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'classId': classId,
      'deviceId': deviceId,
      'reporterId': reporterId,
      'description': description,
      'status': status,
      'assignedTo': assignedTo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
